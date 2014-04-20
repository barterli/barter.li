require 'digest/md5'
class Api::V1::MessagesController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:create, :ampq]

  def create
    raise "No user present" if User.find(params[:sender_id]).blank?
    @msg_id = current_user.id > params[:sender_id].to_i ? (current_user.id.to_s+params[:sender_id].to_s):(params[:sender_id].to_s+current_user.id.to_s)
    @msg_id = Digest::MD5.hexdigest('chat'+@msg_id+"barter")
    @chat = Chat.find_by(:msg_id => @msg_id)
   if(@chat.blank?)
     @chat = Chat.create(msg_id: @msg_id)
     @chat.chat_groups.create(user_id: params[:sender_id])
     @chat.chat_groups.create(user_id: current_user.id)
   end
    @message = @chat.messages.create(body: params[:message], msg_to: params[:sender_id], msg_from: current_user.id)
    PrivatePub.publish_to("/messages/#{@msg_id}", params[:message])
    render json: {status: :sent}
   rescue
    render json: {status: :error}
  end

  def public
    PrivatePub.publish_to("/messages", params[:message])
    render json: {status: :sent}
  end

  def set_message
    @sender = User.find_by(:id_user => params[:sender_id])
    @receiver = User.find_by(:id_user => params[:receiver_id])
    sender_hash = {"id_user" => @sender.id_user, "first_name" => @sender.first_name, 
                  "last_name" => @sender.last_name, "profile_image" => @sender.absolute_profile_image(request.host_with_port)}
    receiver_hash = {"id_user" => @receiver.id_user, "first_name" => @receiver.first_name, 
                    "last_name" => @receiver.last_name, "profile_image" => @receiver.absolute_profile_image(request.host_with_port) }
    @chat_hash = {"sender" => sender_hash, "receiver" => receiver_hash,
      "message" => params[:message], "time" => Time.now}
  end


  def ampq
    EM.next_tick {
    set_message
    AMQP.channel ||= AMQP::Channel.new(AMQP.connect(:host => '127.0.0.1', :user=>ENV["RABBITMQ_USERNAME"], :pass => ENV["RABBITMQ_PASSWORD"], :vhost => "/"))
    channel  = AMQP.channel
    exchange = channel.direct("node.barterli")
    receiver_queue    = channel.queue(@receiver.id_user+"queue", :auto_delete => true).bind(exchange, :routing_key => @receiver.id_user)
    sender_queue    = channel.queue(@sender.id_user+"queue", :auto_delete => true).bind(exchange, :routing_key => @sender.id_user)
    exchange.publish(@chat_hash.to_json, :routing_key => @receiver.id_user)
    exchange.publish(@chat_hash.to_json, :routing_key => @sender.id_user)
    # receiver_queue.subscribe do |metadata, payload|
    #   puts "Received a message: #{metadata.message_id},#{payload}. Disconnecting..."
    # end
    EventMachine::error_handler { |e| puts "error! in eventmachine" }
     render json: {}

   }
  rescue => e
    Rails.logger.info "error! #{e}"
 end

  def ampq1
    EventMachine.run do
      set_message
      AMQP.channel ||= AMQP::Channel.new(AMQP.connect(:host => '127.0.0.1', :user=>ENV["RABBITMQ_USERNAME"], :pass => ENV["RABBITMQ_PASSWORD"], :vhost => "/"))
      channel  = AMQP.channel
      exchange = channel.direct("node.barterli")
      receiver_queue    = channel.queue(@receiver.id_user+"queue", :auto_delete => true).bind(exchange, :routing_key => @receiver.id_user)
      sender_queue    = channel.queue(@sender.id_user+"queue", :auto_delete => true).bind(exchange, :routing_key => @sender.id_user)
      exchange.publish(@chat_hash.to_json, :routing_key => @receiver.id_user)
      exchange.publish(@chat_hash.to_json, :routing_key => @sender.id_user)
      # receiver_queue.subscribe do |metadata, payload|
      #   puts "Received a message: #{metadata.message_id},#{payload}. Disconnecting..."
      # end
      EventMachine::error_handler { |e| puts "error! in eventmachine" }
        render json: {}
    end
  end

end