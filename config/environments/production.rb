BarterLi::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true


  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like nginx, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_assets = true
  
  # for rac-cache -manual
  config.static_cache_control = "public, max-age=2592000"
  
  # for rack cache using redis -manual
  config.action_dispatch.rack_cache = {
    metastore:   'redis://localhost:6379/1/metastore',
    entitystore: 'redis://localhost:6379/1/entitystore'
   }

  # Compress JavaScripts and CSS.
  # removed due to rails api
  # config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass
  
  # assets other than application.css
  #config.assets.precompile = ['*.js', '*.css', '*.css.erb']
  config.assets.precompile += %w( public/welcome.css framework_and_overrides.css )
  #config.assets.precompile += %w( *.css *.css.erb' )
  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Set to :debug to see everything in the log.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
  # config.assets.precompile += %w( search.js )

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Disable automatic flushing of the log to improve performance.
  # config.autoflush_log = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new
  
  # for angular.js
  # config.assets.js_compressor = Uglifier.new(mangle: false)

    #added for devise and sending mail
  config.action_mailer.default_url_options = { :host => 'http://162.243.198.171' }
  #change false for production
  config.action_mailer.perform_deliveries = true 
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
   :address              => "smtp.gmail.com",
   :port                 => 587,
   :enable_starttls_auto => true,
   :user_name            => ENV["SMTP_USERNAME_DEV"],
   :password             => ENV["SMTP_PASSWORD_DEV"],
   :domain               => 'barter.li',
   :authentication       => 'plain'
 }
end
