require "rubygems"
require "bundler/setup"

module BomberoClient
  autoload :RackMiddleware, 'bombero_client/rack_middleware'
  autoload :Assets, 'bombero_client/assets'  
end  