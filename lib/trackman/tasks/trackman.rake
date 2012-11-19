require 'rest-client'
require 'trackman'

#only load this rakefile for sinatra/rack apps 
namespace :trackman do
  desc "Syncs your assets with the server, this is what gets executed when you deploy to heroku."
  task :sync do 
    Trackman::Assets::Asset.sync
  end

  desc "Sets up the heroku configs required by Trackman"
  task :setup, :app do |t, args|
    Trackman::Utility::Configuration.new(:app => args[:app]).setup
  end
end
