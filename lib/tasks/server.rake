namespace :server do
  desc "start thin server"
  task start: :environment do
  	 `cd #{Rails.root}`
  	 str  = "rails s -e production"
  	 puts "Starting server" 
  	 `#{str}`
  end
end





