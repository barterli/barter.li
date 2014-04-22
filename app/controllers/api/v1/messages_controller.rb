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
    begin
      set_message
    rescue => e
      Rails.logger.info "error! #{e}"
      render json: {error: "message not send"}
      return
    end
    connection = AMQP.connect(:host => '127.0.0.1', :user=>ENV["RABBITMQ_USERNAME"], :pass => ENV["RABBITMQ_PASSWORD"], :vhost => "/")
    AMQP.channel ||= AMQP::Channel.new(connection)
    channel  = AMQP.channel
    channel.auto_recovery = true
    exchange = channel.fanout(params[:exchange])
    receiver_queue    = channel.queue(@receiver.id_user+"queue", :auto_delete => true).bind(exchange)
    sender_queue    = channel.queue(@sender.id_user+"queue", :auto_delete => true).bind(exchange)
    exchange.publish(@chat_hash.to_json)
    exchange.publish(@chat_hash.to_json)
    receiver_queue.status do |number_of_messages, number_of_consumers|
      puts
      puts "(receiver queue)# of messages in the queue  = #{number_of_messages}"
      puts
    end
    sender_queue.status do |number_of_messages, number_of_consumers|
      puts
      puts "(sender queue)# of messages in the queue  = #{number_of_messages}"
      puts
    end
    Rails.logger.info "enterd event loop"
    EventMachine.add_timer(2) do
      exchange.delete
    end
    connection.on_tcp_connection_loss do |connection, settings|
      # reconnect in 10 seconds, without enforcement
      connection.reconnect(false, 10)
    end
    connection.on_error do |conn, connection_close|
      puts <<-ERR
      Handling a connection-level exception.
      AMQP class id : #{connection_close.class_id},
      AMQP method id: #{connection_close.method_id},
      Status code   : #{connection_close.reply_code}
      Error message : #{connection_close.reply_text}
      ERR
     conn.periodically_reconnect(30)
    end
    EventMachine::error_handler { |e| puts "error! in eventmachine #{e}" }
     render json: {}

    }
 
  end
  


  def ampq2
    EM.next_tick {
    begin
      set_message
    rescue => e
      Rails.logger.info "error! #{e}"
      render json: {error: "message not send"}
      return
    end
    connection = AMQP.connect(:host => '127.0.0.1', :user=>ENV["RABBITMQ_USERNAME"], :pass => ENV["RABBITMQ_PASSWORD"], :vhost => "/")
    AMQP.channel ||= AMQP::Channel.new(connection)
    channel  = AMQP.channel
    channel.auto_recovery = true
    exchange = channel.direct("node.barterli")
    receiver_queue    = channel.queue(@receiver.id_user+"queue", :auto_delete => true).bind(exchange, :routing_key => @receiver.id_user)
    sender_queue    = channel.queue(@sender.id_user+"queue", :auto_delete => true).bind(exchange, :routing_key => @sender.id_user)
    exchange.publish(@chat_hash.to_json, :routing_key => @receiver.id_user)
    exchange.publish(@chat_hash.to_json, :routing_key => @sender.id_user)
    receiver_queue.status do |number_of_messages, number_of_consumers|
      puts
      puts "(receiver queue)# of messages in the queue  = #{number_of_messages}"
      puts
    end
    sender_queue.status do |number_of_messages, number_of_consumers|
      puts
      puts "(sender queue)# of messages in the queue  = #{number_of_messages}"
      puts
    end
    Rails.logger.info "enterd event loop"
    connection.on_tcp_connection_loss do |connection, settings|
      # reconnect in 10 seconds, without enforcement
      connection.reconnect(false, 10)
    end
    connection.on_error do |conn, connection_close|
      puts <<-ERR
      Handling a connection-level exception.
      AMQP class id : #{connection_close.class_id},
      AMQP method id: #{connection_close.method_id},
      Status code   : #{connection_close.reply_code}
      Error message : #{connection_close.reply_text}
      ERR
     conn.periodically_reconnect(30)
    end
    EventMachine::error_handler { |e| puts "error! in eventmachine #{e}" }
     render json: {}

   }
 
 end

  def ampq1
    AMQP.start("amqp://#{ENV["RABBITMQ_USERNAME"]}:#{ENV["RABBITMQ_PASSWORD"]}@127.0.0.1") do |connection|
    set_message
    channel  = AMQP::Channel.new(connection)
    exchange = channel.direct("node.barterli")
    receiver_queue    = channel.queue(@receiver.id_user+"queue", :auto_delete => true).bind(exchange, :routing_key => @receiver.id_user)
    sender_queue    = channel.queue(@sender.id_user+"queue", :auto_delete => true).bind(exchange, :routing_key => @sender.id_user)
    exchange.publish(@chat_hash.to_json, :routing_key => @receiver.id_user)
    exchange.publish(@chat_hash.to_json, :routing_key => @sender.id_user)
    EventMachine::error_handler { |e| puts "error! in eventmachine #{e}" }
    # disconnect & exit after 2 seconds
    connection.on_error do |conn, connection_close|
      puts <<-ERR
      Handling a connection-level exception.
      AMQP class id : #{connection_close.class_id},
      AMQP method id: #{connection_close.method_id},
      Status code   : #{connection_close.reply_code}
      Error message : #{connection_close.reply_text}
      ERR
     conn.periodically_reconnect(30)
    end

    EventMachine.add_timer(2) do
      exchange.delete
      end
    end
  end



end


