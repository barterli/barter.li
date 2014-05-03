RAILS_ROOT = File.dirname(File.dirname(__FILE__))
CONF = File.expand_path('config.ru', File.dirname(File.dirname(__FILE__)))
rake_root = ENV['RAKE_ROOT']

God.watch do |w|
  pid_file = File.join(RAILS_ROOT, "tmp/pids/server.pid")

  w.name = "thin"
  w.interval = 60.seconds
  #w.start = exec("thin -e production -R #{CONF} --debug start")
  w.start   = "cd #{RAILS_ROOT} && rake server:start"
  w.stop = "kill -s QUIT $(cat #{pid_file})"
  w.restart = "kill -s HUP $(cat #{pid_file})"
  w.start_grace = 20.seconds
  w.restart_grace = 20.seconds
  w.pid_file = pid_file
  w.env = {'RAILS_ENV' => "production" }

  w.behavior(:clean_pid_file)

  # When to start?
  w.start_if do |start|
    start.condition(:process_running) do |c|
      # We want to check if deamon is running every ten seconds
      # and start it if itsn't running
      c.interval = 10.seconds
      c.running = false
    end
  end

  # When to restart a running deamon?
  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      # Pick five memory usage at different times
      # if three of them are above memory limit (100Mb)
      # then we restart the deamon
      c.above = 100.megabytes
      c.times = [3, 5]
    end

    restart.condition(:cpu_usage) do |c|
      # Restart deamon if cpu usage goes
      # above 90% at least five times
      c.above = 90.percent
      c.times = 5
    end
  end

  w.lifecycle do |on|
    # Handle edge cases where deamon
    # can't start for some reason
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart] # If God tries to start or restart
      c.times = 5                     # five times
      c.within = 5.minute             # within five minutes
      c.transition = :unmonitored     # we want to stop monitoring
      c.retry_in = 10.minutes         # for 10 minutes and monitor again
      c.retry_times = 5               # we'll loop over this five times
      c.retry_within = 2.hours        # and give up if flapping occured five times in two hours
    end
  end
end
