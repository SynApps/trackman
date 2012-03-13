require "rubygems"
require "bundler/setup"

module Trackman
  autoload :RackMiddleware, 'trackman/rack_middleware'
  autoload :Assets, 'trackman/assets'
end  