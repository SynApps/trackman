require 'versionomy'

module Trackman
	class ConfigurationHandler
		@@ERROR = 'ERROR_PAGE_URL'
	  @@MAINTENANCE = 'MAINTENANCE_PAGE_URL'
	  @@TRACKMAN_ERROR = 'TRACKMAN_ERROR_PAGE_URL'
	  @@TRACKMAN_MAINTENANCE = 'TRACKMAN_MAINTENANCE_PAGE_URL'

	  attr_accessor :configs, :heroku_version, :options

	  def initialize(heroku_version, options = {})
	  	self.options = options
      self.heroku_version = heroku_version
      self.configs = get_configs
	  end

    def setup
	    raise SetupException, "Your heroku version is too low, trackman requires '~> 2.26'." unless is_heroku_valid
      rename_configs
      add_configs
      puts "Done!"
	  end

    def get_configs
      result = run "heroku config -s" do |option|
        "heroku config -s #{option}"
      end
      Trackman::ConfigurationHandler.s_to_h(result)
    end
    

	  def add_configs
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
	      add_config add
	    end
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

		private
		  def is_heroku_valid
		  	Versionomy.parse(heroku_version) >= Versionomy.parse("2.26.2")
		  end

		  def add_config add
        run "heroku config:add #{add}" do |option|
          "heroku config:add #{option} #{add}"
        end
		  end

      def run command
        command = yield("--app #{options[:app]}") unless self.options[:app].nil?
        puts "exec: #{command}"
        result = `#{command}`
        raise "An error occured running the last command." if $? != 0
        result
      end
	end

	class SetupException < Exception
	end
end
