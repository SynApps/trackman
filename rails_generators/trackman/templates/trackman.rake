require 'trackman'
namespace :trackman do
  ERROR = 'ERROR_PAGE_URL'
  MAINTENANCE = 'MAINTENANCE_PAGE_URL'
  TRACKMAN_ERROR = 'TRACKMAN_ERROR_PAGE_URL'
  TRACKMAN_MAINTENANCE = 'TRACKMAN_MAINTENANCE_PAGE_URL'

  desc "Syncs your assets with the server, this is what gets executed when you deploy to heroku."
  task :sync, :debug do |t, args|
    if args[:debug]
      RestClient.log = Logger.new(STDOUT)
    end
    Trackman::Assets::Asset.sync
  end

  desc "Sets up the heroku configs required by Trackman" 
  task :setup do
    heroku_version = `heroku version`
    if heroku_version !~ /^[2-9]\.[2-9]/
      puts "your heroku version is too low, we recommend '~> 2.26' at least"
    else
      configs = `heroku config -s` 
      rename_configs configs
      add_configs configs
      puts "done! Thank you for using Trackman!"
    end
  end 

  def rename_configs configs
    bkp = {}

    [ERROR, MAINTENANCE].each do |c|
      bkp[c] = extract_config_value(configs, c) if configs.include? c
    end
    
    add = Hash[bkp.map {|k, v| [k + ".bkp", v] }].map{|k,v| "#{k}=#{v}" }.join(' ')
    
    `heroku config:add #{add}`
    puts "backuping configs to heroku...\n running heroku config:add #{add}"
  end

  def add_configs configs
    puts "overriding the required heroku configs #{MAINTENANCE} and #{ERROR}"

    if configs.include?(TRACKMAN_ERROR) && configs.include?(TRACKMAN_MAINTENANCE)
      trackman_configs = {}
      [[TRACKMAN_ERROR, ERROR], [TRACKMAN_MAINTENANCE, MAINTENANCE]].each do |old_c, new_c|
        trackman_configs[new_c] = extract_config_value(configs, old_c)
      end

      add = trackman_configs.map{|k,v| "#{k}=#{v}" }.join(' ')
      `heroku config:add #{add}`
      puts "running heroku config:add #{add}"
    else
      puts "cannot find trackman configuration, make sure trackman addon is installed"
    end
  end

  def extract_config_value configs, name
    configs[/#{name}=.+$/][/[^=]+$/]
  end
end