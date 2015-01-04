# require 'amqp'

# module ThinEM
#   def self.start
#     EventMachine.next_tick do
#       AMQP.channel ||= AMQP::Channel.new(AMQP.connect(:host => '127.0.0.1', :user=>ENV["RABBITMQ_USERNAME"], :pass => ENV["RABBITMQ_PASSWORD"], :vhost => "/"))
#       puts "thin em started"
#     end
#   end
# end


module ThinEM
  def self.start
    EventMachine.next_tick do
      connection = AMQP.connect(AMQP.connect(:host => '127.0.0.1', :user=>ENV["RABBITMQ_USERNAME"], :pass => ENV["RABBITMQ_PASSWORD"], :vhost => "/"))
      AMQP.channel ||= AMQP::Channel.new(connection)
      channel = AMQP.channel
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

      #-------------------
       puts "thin em started"
    end
  end
end


module PassengerEM
  def self.start
    PhusionPassenger.on_event(:starting_worker_process) do |forked|
      # for passenger, we need to avoid orphaned threads
        if forked && EM.reactor_running?
          EM.stop
        end
        Thread.new {
          EM.run do
            AMQP.channel ||= AMQP::Channel.new(AMQP.connect(:host => '127.0.0.1', :user=>ENV["RABBITMQ_USERNAME"], :pass => ENV["RABBITMQ_PASSWORD"], :vhost => "/"))
          end
          }
        die_gracefully_on_signal
     end
  end
  

  def self.die_gracefully_on_signal
    Signal.trap("INT") { EM.stop }
    Signal.trap("TERM") { EM.stop }
  end
end

if defined?(PhusionPassenger)
  PassengerEM.start
end

# if defined?(Thin)
#   ThinEM.start
# end