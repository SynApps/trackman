require 'versionomy'

module Trackman
	class ConfigurationHandler
		@@ERROR = 'ERROR_PAGE_URL'
	  @@MAINTENANCE = 'MAINTENANCE_PAGE_URL'
	  @@TRACKMAN_ERROR = 'TRACKMAN_ERROR_PAGE_URL'
	  @@TRACKMAN_MAINTENANCE = 'TRACKMAN_MAINTENANCE_PAGE_URL'

	  attr_accessor :configs, :heroku_version 

	  def initialize(configs, heroku_version)
	  	self.configs = configs
	  	self.heroku_version = heroku_version
	  end

	  def setup
	    unless is_heroku_valid
	      raise SetupException, "your heroku version is too low, we recommend '~> 2.26' at least"
	    else
	      rename_configs
	      add_configs
	      puts "done! Thank you for using Trackman!"
	    end
	  end

	  def add_configs
	    puts "overriding the required heroku configs #{@@MAINTENANCE} and #{@@ERROR}"

	    if configs.include?(@@TRACKMAN_ERROR) && configs.include?(@@TRACKMAN_MAINTENANCE)
	      trackman_configs = {}
	      [[@@TRACKMAN_ERROR, @@ERROR], [@@TRACKMAN_MAINTENANCE, @@MAINTENANCE]].each do |old_c, new_c|
	        trackman_configs[new_c] = configs[old_c]
	      end

	      add = trackman_configs.map{|k,v| "#{k}=#{v}" }.join(' ')
	      add_config add
	    else
	      raise SetupException, "cannot find trackman configuration, make sure trackman addon is installed"
	    end
	  end

	  def rename_configs
	    bkp = {}
	    [@@ERROR, @@MAINTENANCE].each do |c|
	      bkp[c] = configs[c] if configs.include? c
	    end
	   
	    add = Hash[bkp.map {|k, v| [k + "_bkp", v] }].map{|k,v| "#{k}=#{v}" }.select{|c| !configs.include? c }.join(' ')
	    
	    unless add.empty?
	    	puts "backing configs to heroku..."
	      add_config add
	    end
	  end

		private
		  def is_heroku_valid
		  	Versionomy.parse(heroku_version) >= Versionomy.parse("2.26.2")
		  end

		  def add_config add
		  	`heroku config:add #{add}`
		  end

			def self.s_to_h configs
				new_configs = {}
				configs.split(" ").each do |a|
					key_val = a.split("=")
					new_configs[key_val[0]] = key_val[1]
				end
				new_configs
			end

			def self.h_to_s configs
				out = []
				configs.each do |k,v|
					out << k + "=" + v
				end
				out.join ' '
			end
	end

	class SetupException < Exception
	end
end