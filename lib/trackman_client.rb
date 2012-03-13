require "rubygems"
require "bundler/setup"

module TrackmanClient
  autoload :RackMiddleware, 'trackman_client/rack_middleware'
  autoload :Assets, 'trackman_client/assets'
end  