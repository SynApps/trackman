require "rubygems"
require "bundler/setup"
require 'tasks'

module Trackman
  autoload :RackMiddleware, 'trackman/rack_middleware'
  autoload :Assets, 'trackman/assets'
end 

if defined?(Rails)
  if ::Rails::VERSION::STRING =~ /^2\.[1-9]/
    Rails.configuration.middleware.use Trackman::RackMiddleware
  elsif ::Rails::VERSION::STRING =~ /^[3-9]\.[1-9]/
    require "trackman/railtie"
  end
end