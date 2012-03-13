require "rubygems"
require "bundler/setup"

module Trackman
  autoload :RackMiddleware, 'trackman_client/rack_middleware'
  autoload :Assets, 'trackman_client/assets'
end  