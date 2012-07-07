require 'rest-client'
require 'trackman'

namespace :trackman do
  desc "Syncs your assets with the server, this is what gets executed when you deploy to heroku."
  task :sync => :environment do 
    RestClient.log = Logger.new(STDOUT) if Debugger.debug_mode?
    Trackman::Assets::Asset.sync
  end

  desc "Sets up the heroku configs required by Trackman" 
  task :setup do
    configs = ConfigurationHandler.s_to_h(`heroku config -s`)
    heroku_version = `heroku -v`[/[\d]*\.[\d]*.[\d]*/]
    ConfigurationHandler.new(configs, heroku_version).setup
  end 
end