EventMachine.next_tick do
  connection = AMQP.connect(:host => '127.0.0.1', :user=>ENV["RABBITMQ_USERNAME"], :pass => ENV["RABBITMQ_PASSWORD"], :vhost => "/")
  puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."
  channel  = AMQP::Channel.new(connection)
  exchange = AMQP::Exchange.new(channel, :direct, "node.barterli")
  #exchange = channel.direct("nodes.metadatap21")
  #queue    = channel.queue("barter.li", :auto_delete => true).bind(exchange, :routing_key => "shared.key")
  # queue.subscribe do |payload|
  #   puts "Received a message: #{payload}. Disconnecting..."
  #   # connection.close { EventMachine.stop }
  # end
  
 end
