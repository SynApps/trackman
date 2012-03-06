require 'bombero_client'
namespace :bombero do
  CEP = 'custom_error_pages'
  ERROR = 'ERROR_PAGE_URL'
  MAINTENANCE = 'MAINTENANCE_PAGE_URL'

  desc "Uploads modified assets to the server"
  task :update do
    Asset.ship
  end

  desc "Setups the configs required by Bombero" 
  task :setup do
    #ensures that custom_error_pages is present
    #`heroku addons:add #{CEP}` unless `heroku addons`.include? CEP
    
    puts "verifying if #{CEP} addon is installed..."
    unless `heroku addons`.include? CEP
      puts "adding #{CEP} addon to heroku..."
      puts "heroku addons:add #{CEP}" 
    end
    remove_configs
    add_configs 
    puts "done! Thank you for using Bombero!"
  end

  def remove_configs
    configs = `heroku config` 
    to_remove = []
    to_remove << ERROR if configs.include? ERROR
    to_remove << MAINTENANCE if configs.include? MAINTENANCE

    puts "removing configs #{to_remove} so we can re-add them with the new urls"   
    #`heroku config:remove #{to_remove.join(' ')}`
    puts "heroku config:remove #{to_remove.join(' ')}"
  end
  def add_configs
    puts "adding configs #{MAINTENANCE} and #{ERROR}"
    #`heroku config:add #{MAINTENANCE}=maintenance #{ERROR}=error`
    puts "heroku config:add #{MAINTENANCE}=maintenance #{ERROR}=error"
  end
end