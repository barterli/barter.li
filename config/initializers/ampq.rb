require 'amqp'

module ThinEM
  def self.start
    EventMachine.next_tick do
      AMQP.channel ||= AMQP::Channel.new(AMQP.connect(:host => '127.0.0.1', :user=>ENV["RABBITMQ_USERNAME"], :pass => ENV["RABBITMQ_PASSWORD"], :vhost => "/"))
      puts "thin em started"
    end
  end
end

module PassengerEM
  def self.start
    if defined?(PhusionPassenger)
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
  end

  def self.die_gracefully_on_signal
    Signal.trap("INT") { EM.stop }
    Signal.trap("TERM") { EM.stop }
  end
end

if defined?(PhusionPassenger)
  PassengerEM.start
end

if defined?(Thin)
  ThinEM.start
end