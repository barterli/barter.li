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
    connection = AMQP.connect(:host => '127.0.0.1')
    channel  = AMQP::Channel.new(connection)
    channel.direct("nodes.metadatap21").publish "Hello, world!", :routing_key => "shared.key"

# EventMachine.next_tick do
#   connection = AMQP.connect(:host => '127.0.0.1')
#   channel  = AMQP::Channel.new(connection)
#   exchange = channel.fanout("nodes.metadatap21")

#   # channel.queue("joe", :auto_delete => true).bind(exchange).subscribe do |payload|
#   #   puts "#{payload} => joe"
#   # end

#   # channel.queue("aaron", :auto_delete => true).bind(exchange).subscribe do |payload|
#   #   puts "#{payload} => aaron"
#   # end

#   # channel.queue("bob", :auto_delete => true).bind(exchange).subscribe do |payload|
#   #   puts "#{payload} => bob"
#   # end

#   exchange.publish("hello world")

#   # disconnect & exit after 2 seconds
#   EventMachine.add_timer(2) do
#     #exchange.delete

#     # connection.close { EventMachine.stop }
#   end
#end
    render :nothing => true
 end



end