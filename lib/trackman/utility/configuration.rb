require 'versionomy'

module Trackman
  module Utility
    class Configuration
      @@ERROR = 'ERROR_PAGE_URL'
      @@MAINTENANCE = 'MAINTENANCE_PAGE_URL'
  	  @@TRACKMAN_ERROR = 'TRACKMAN_ERROR_PAGE_URL'
  	  @@TRACKMAN_MAINTENANCE = 'TRACKMAN_MAINTENANCE_PAGE_URL'

  	  attr_accessor :configs, :heroku_version, :options

  	  def initialize(options = {})
  	  	self.options = options
        self.heroku_version = get_version
        self.configs = get_configs
  	  end

      def setup
  	    raise Trackman::Errors::ConfigSetupError, "Your heroku version is too low, trackman requires '~> 2.26'." unless is_heroku_valid
        rename_configs
        add_configs
  	  end

      def get_version
        Bundler.with_clean_env do
          which_result = `which heroku`
          raise 'Could not find heroku toolbelt or gem. Make sure you installed one of them.' unless which_result && which_result.length > 0
        
          heroku_version = `heroku --version`
          heroku_version.match(/heroku-.*(\d+\.?\d+\.?\d+).*\(/)[1] 
        end
      end
      
      def get_configs
        Bundler.with_clean_env do
          result = run "heroku config -s" do |option|
            "heroku config -s #{option}"
          end
          self.class.s_to_h(result)
        end
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
  	      raise Trackman::Errors::ConfigSetupError, "cannot find trackman configuration, make sure trackman addon is installed"
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
          Bundler.with_clean_env do
            run "heroku config:add #{add}" do |option|
              "heroku config:add #{option} #{add}"
            end
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
  end
end
