require 'trackman'
namespace :trackman do
  CEP = 'custom_error_pages'
  ERROR = 'ERROR_PAGE_URL'
  MAINTENANCE = 'MAINTENANCE_PAGE_URL'
  TRACKMAN_ERROR = 'TRACKMAN_ERROR_PAGE_URL'
  TRACKMAN_MAINTENANCE = 'TRACKMAN_MAINTENANCE_PAGE_URL'

  desc "Syncs your assets with the server, this is what gets executed when you deploy to heroku."
  task :sync do
    Trackman::Assets::Asset.sync
  end

  desc "Setups the heroku configs required by Trackman" 
  task :setup do
    if `bundle list`.include? 'heroku'
      rename_configs
      add_configs 
      puts "done! Thank you for using Trackman!"
    else
      puts "heroku is not installed!"
      puts "please install it before running this setup."
    end
  end 

  def rename_configs
    configs = `heroku config -s` 
    remove = {}

    [ERROR, MAINTENANCE].each do |c|
      remove[c] = configs[/#{c}=.+$/][/[^=]+$/] if configs.include? c
    end
    
    add = Hash[remove.map {|k, v| [k + ".bkp", v] }].map{|k,v| "#{k}=#{v}" }.join(' ')
    
    remove = remove.map{|k,v| k }.join(' ')

    puts "heroku config:add #{add}"
    puts "heroku config:remove #{remove}"
  end
  def add_configs
    puts "adding configs #{MAINTENANCE} and #{ERROR}"
    `heroku config:add #{MAINTENANCE}=#{ENV[TRACKMAN_MAINTENANCE]} #{ERROR}=#{ENV[TRACKMAN_ERROR]}`
    puts "heroku config:add #{MAINTENANCE}=#{ENV[TRACKMAN_MAINTENANCE]} #{ERROR}=#{ENV[TRACKMAN_ERROR]}"
  end
end