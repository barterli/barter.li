# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application

# rack-cache backend -manual

require 'rack'
require 'rack/cache'
require 'redis-rack-cache'
 
use Rack::Cache,
metastore: 'redis://localhost:6379/0/metastore',
entitystore: 'redis://localhost:6380/0/entitystore'