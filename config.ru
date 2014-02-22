# This file is used by Rack-based servers to start the application.
require 'resque/server'
require 'resque/status_server'

require ::File.expand_path('../config/environment',  __FILE__)
#run Rails.application
run Rack::URLMap.new "/" => Rails.application, "/resque" => Resque::Server.new

