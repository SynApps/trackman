require 'rest-client'
require 'trackman'

namespace :trackman do
  desc "Syncs your assets with the server, this is what gets executed when you deploy to heroku."
  task :sync => :environment do 
    RestClient.log = Logger.new(STDOUT) if Debugger.debug_mode?
    Trackman::Assets::Asset.sync
  end

  desc "Sets up the heroku configs required by Trackman"
  task :setup, :app do |t, args|
    
    heroku_version = Gem.loaded_specs["heroku"].version.to_s
    Trackman::ConfigurationHandler.new(heroku_version, app: args[:app]).setup
  end
end