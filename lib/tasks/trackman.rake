require 'trackman'
namespace :trackman do
  CEP = 'custom_error_pages'
  ERROR = 'ERROR_PAGE_URL'
  MAINTENANCE = 'MAINTENANCE_PAGE_URL'

  desc "Syncs your assets with the server, this is what gets executed when you deploy to heroku."
  task :sync do
    Trackman::Assets::Asset.sync
  end

  #TODO : check if heroku is installed and if app is deployed?
  desc "Setups the heroku configs required by Trackman" 
  task :setup do
    # ensures that custom_error_pages addon is present
    #`heroku addons:add #{CEP}` unless `heroku addons`.include? CEP
    
    puts "verifying if #{CEP} addon is installed..."
    unless `heroku addons`.include? CEP
      puts "adding #{CEP} addon to heroku..."
      puts "heroku addons:add #{CEP}" 
    end
    rename_configs
    add_configs 
    puts "done! Thank you for using Trackman!"
  end 

  def rename_configs
    configs = `heroku config -s` 
    remove = {}

    [ERROR, MAINTENANCE].each do |c|
      remove[c] = configs[/#{c}=.+$/][/[^=]+$/] if configs.include? c
    end
    
    add = Hash[remove.map {|k, v| [k + ".bkp", v] }]
      .map{|k,v| "#{k}=#{v}" }
      .join(' ')
    
    remove = remove.map{|k,v| k }.join(' ')

    puts "heroku config:add #{add}"
    puts "heroku config:remove #{remove}"
  end
  def add_configs
    puts "adding configs #{MAINTENANCE} and #{ERROR}"
    #`heroku config:add #{MAINTENANCE}=maintenance #{ERROR}=error`
    puts "heroku config:add #{MAINTENANCE}=maintenance #{ERROR}=error"
  end
end