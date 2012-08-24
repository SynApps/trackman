require 'spec_helper'

class TestConfigurationHandler < Trackman::ConfigurationHandler
  def get_configs
    {
      "TRACKMAN_MAINTENANCE_PAGE_URL" => "\"en_US.UTF-8\"",
      "TRACKMAN_URL" => "\"url\"",
      "TRACKMAN_ERROR_PAGE_URL" => "\"error_page_url\"",
      "SOME_CONFIG" => "\"url\""
    }
  end
  attr_accessor :heroku_configs

  def add_config add
    self.heroku_configs = (heroku_configs || {}).merge(ConfigurationHandler.s_to_h(add))
  end

  def run command
    puts "exec: #{command}"
  end
end

describe ConfigurationHandler do
  before :each do 
    @config = TestConfigurationHandler.new "2.26.2"
  end

	it "creates heroku configs" do
		
		@config.setup
		
    config_hash = @config.heroku_configs

		config_hash.should include("ERROR_PAGE_URL")
    config_hash.should include("MAINTENANCE_PAGE_URL")
		config_hash["ERROR_PAGE_URL"].should == "\"error_page_url\""
		config_hash["MAINTENANCE_PAGE_URL"].should == "\"en_US.UTF-8\""
	end

	it "raises an error if a configuration is missing" do
    @config.configs = {
      "TRACKMANw_MAINTENANCE_PAGE_URL" => "\"en_US.UTF-8\"",
			"TRACKMANw_URL" => "\"url\"",
			"TRACKMANw_ERROR_PAGE_URL" => "\"error_page_url\""
		}
		
		lambda{ @config.setup }.should raise_error(Trackman::SetupException)
	end

	it "raises an error if trackman version is bad" do
		@config.heroku_version = "2.22.2" 

		lambda{ @config.setup }.should raise_error(Trackman::SetupException)
	end

	it "backups configs when they already exist and add the new ones" do
		@config.configs = {"TRACKMAN_MAINTENANCE_PAGE_URL" => "\"en_US.UTF-8\"",
								"TRACKMAN_URL" => "\"url\"",
								"TRACKMAN_ERROR_PAGE_URL" => "\"error_page_url\"",
								"MAINTENANCE_PAGE_URL" => "\"en_US.UTF-8_old\"",
								"SOME_CONFIG" => "\"url\"",
								"ERROR_PAGE_URL" => "\"error_page_url_old\""
							}
		@config.setup


		@config.heroku_configs["ERROR_PAGE_URL_bkp"].should == "\"error_page_url_old\""
		@config.heroku_configs["MAINTENANCE_PAGE_URL_bkp"].should == "\"en_US.UTF-8_old\""
		@config.heroku_configs["ERROR_PAGE_URL"].should == "\"error_page_url\""
		@config.heroku_configs["MAINTENANCE_PAGE_URL"].should == "\"en_US.UTF-8\""
	end

	it "does not backup configs when they do not exist" do
		@config.configs = {"TRACKMAN_MAINTENANCE_PAGE_URL" => "\"en_US.UTF-8\"",
								"TRACKMAN_URL" => "\"url\"",
								"TRACKMAN_ERROR_PAGE_URL" => "\"error_page_url\"",
								"SOME_CONFIG" => "\"url\""
							}
		
		@config.setup
		

		@config.heroku_configs.keys.should_not include("ERROR_PAGE_URL_bkp")
		@config.heroku_configs.keys.should_not include("MAINTENANCE_PAGE_URL_bkp")
		@config.heroku_configs["ERROR_PAGE_URL"].should == "\"error_page_url\""
		@config.heroku_configs["MAINTENANCE_PAGE_URL"].should ==  "\"en_US.UTF-8\""
	end
end