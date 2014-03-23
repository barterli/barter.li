require 'digest/md5'
class Api::V1::MessagesController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:create]

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

  
  def ampq
    connection = AMQP.connect(:host => '127.0.0.1', :user=>ENV["RABBITMQ_USERNAME"], :pass=>ENV["RABBITMQ_PASSWORD"] , :vhost => "/")
    channel  = AMQP::Channel.new(connection)
    exchange = channel.direct("node.barterli")
    queue    = channel.queue("user1", :auto_delete => true).bind(exchange, :routing_key => "shared.key")
    exchange.publish "Hello, world!", :routing_key => "shared.key"
    render :nothing => true
 end



end