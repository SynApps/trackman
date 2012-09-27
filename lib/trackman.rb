require 'rubygems'
require 'bundler/setup'

require File.expand_path('../trackman/core_extensions', __FILE__)
require File.expand_path('../trackman_railtie', __FILE__)

module Trackman
  autoload :Assets, 'trackman/assets'
  autoload :ConfigurationHandler, 'trackman/configuration_handler'
  autoload :Scaffold, 'trackman/scaffold'
end 

autoload :Debugger, 'trackman/debugger'