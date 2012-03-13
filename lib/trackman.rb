require "rubygems"
require "bundler/setup"
require 'tasks'

module Trackman
  autoload :RackMiddleware, 'trackman/rack_middleware'
  autoload :Assets, 'trackman/assets'
end 