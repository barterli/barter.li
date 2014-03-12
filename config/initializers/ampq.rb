EventMachine.next_tick do
  connection = AMQP.connect(:host => '127.0.0.1')
  puts "Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."
  channel  = AMQP::Channel.new(connection)
  exchange = AMQP::Exchange.new(channel, :direct, "nodes.metadata7")
  exchange = channel.direct("nodes.metadata7")
  queue    = channel.queue("amqpgem.examples.helloworld7", :auto_delete => true).bind(exchange, :routing_key => "shared.key")
  queue.subscribe do |payload|
    puts "Received a message: #{payload}. Disconnecting..."
    # connection.close { EventMachine.stop }
  end
 # exchange.publish "Hello, world!", :routing_key => "shared.key"
 end
