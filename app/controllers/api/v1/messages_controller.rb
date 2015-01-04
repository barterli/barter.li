require 'digest/md5'
class Api::V1::MessagesController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:create, :ampq]

  def set_message
    @send_receiver  = true
    @sender = User.find_by(:id_user => params[:sender_id])
    @receiver = User.find_by(:id_user => params[:receiver_id])
    sender_hash = {"id_user" => @sender.id_user, "first_name" => @sender.first_name, 
                  "last_name" => @sender.last_name, "profile_image" => @sender.absolute_profile_image(request.host_with_port)}
    receiver_hash = {"id_user" => @receiver.id_user, "first_name" => @receiver.first_name, 
                    "last_name" => @receiver.last_name, "profile_image" => @receiver.absolute_profile_image(request.host_with_port) }
    if(@receiver.is_chat_blocked(@sender.id))
      params[:message] = "Chat is blocked by user"
      @send_receiver = false
    end
    @chat_hash = {"sender" => sender_hash, "receiver" => receiver_hash,
      "message" => params[:message], "sent_at" => params[:sent_at], :time => Time.now}
  end




  # @url /ampq
  # @action post
  # 
  # sent a chat message
  #
  # @required [String] sender_id  guid of sender
  # @required [String] sender_id  guid of receiver
  # @required [String] message chat message
  # @example_request_description Let's send a chat request
  # 
  # @example_request
  #    ```json
  #    {  
  #     sender_id: dksjf945094fn,
  #     receiver_id: fkj324dff,
  #     message: "Test",
  #     sent_at: "11:12"
  #     }
  #    ```
  # @example_response_description a sucess 200 ok code
  # @example_response
  #    ```json
  #        {
  #            {
  #          }   
  #    }
  #    ```
  def ampq
    begin
      set_message
    rescue => e
      Rails.logger.info "error! #{e}"
      render json: {error: "message not send"}
      return
    end
    channel  = AMQP.channel
    channel.auto_recovery = true
    if(@send_receiver)
      receiver_exchange = channel.fanout(@receiver.id_user+"exchange")
      receiver_exchange.publish(@chat_hash.to_json)
    end
    sender_exchange = channel.fanout(@sender.id_user+"exchange") 
    sender_exchange.publish(@chat_hash.to_json)
    # receiver_queue    = channel.queue(@receiver.id_user+"queue", :auto_delete => true).bind(receiver_exchange)
    # sender_queue    = channel.queue(@sender.id_user+"queue", :auto_delete => true).bind(sender_exchange)
    
    # receiver_queue.status do |number_of_messages, number_of_consumers|
    #   puts
    #   puts "(receiver queue)# of consumers in the queue  = #{number_of_consumers}"
    #   puts
    # end
    # sender_queue.status do |number_of_messages, number_of_consumers|
    #   puts
    #   puts "(sender queue)# of consumers in the queue  = #{number_of_consumers}"
    #   puts
    # end
  end

end


