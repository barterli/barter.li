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
    @sender = User.find(params[:sender_id])
    @receiver = User.find(params[:receiver_id])
    @chat_hash =  Hash.new
    @chat_hash = {"sender_id" => @sender.id, "receiver_id" => @receiver.id, "message" => params[:message], :time => Time.now}
  end


  def ampq
    chat_hash = {"sender_id" => "20", "receiver_id" => "30", "message" => "hello", :time => Time.now}
    connection = AMQP.connect(:host => '127.0.0.1', :user=>ENV["RABBITMQ_USERNAME"], :pass=>ENV["RABBITMQ_PASSWORD"] , :vhost => "/")
    channel  = AMQP::Channel.new(connection)
    exchange = channel.direct("node.barterli")
    receiver_queue    = channel.queue(@receiver.email, :auto_delete => true).bind(exchange, :routing_key => @receiver.id_user)
    sender_queue    = channel.queue(@sender.email, :auto_delete => true).bind(exchange, :routing_key => @sender.id_user)
    exchange.publish(@chat_hash, :routing_key => @receiver.id_user
                  )
    # queue.subscribe do |metadata, payload|
    #   puts "Received a message: #{metadata.message_id},#{payload}. Disconnecting..."
    # end
     render :nothing => true

 end



end