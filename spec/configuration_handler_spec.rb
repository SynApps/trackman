require 'spec_helper'

describe ConfigurationHandler do
  before :each do
    module Trackman
    	class ConfigurationHandler
			  def add_config add	
		  		self.configs = configs.merge(ConfigurationHandler.s_to_h(add))
		  	end
    	end
    end
  end

	it "should create heroku configs" do
		configs = {"TRACKMAN_MAINTENANCE_PAGE_URL" => "\"en_US.UTF-8\"",
						"TRACKMAN_URL" => "\"url\"",
						"TRACKMAN_ERROR_PAGE_URL" => "\"error_page_url\"",
						"SOME_CONFIG" => "\"url\""
					}

		config_handler= ConfigurationHandler.new(configs, "2.26.2")
		config_handler.setup
		config_hash = config_handler.configs


		config_hash.should include("ERROR_PAGE_URL")
		config_hash.should include("MAINTENANCE_PAGE_URL")
		config_hash["ERROR_PAGE_URL"].should == "\"error_page_url\""
		config_hash["MAINTENANCE_PAGE_URL"].should == "\"en_US.UTF-8\""
	end

	it "should raise an error if a configuration is missing" do
		configs = {"TRACKMANw_MAINTENANCE_PAGE_URL" => "\"en_US.UTF-8\"",
											"TRACKMANw_URL" => "\"url\"",
											"TRACKMANw_ERROR_PAGE_URL" => "\"error_page_url\""
										}
		
		config_handler = ConfigurationHandler.new(configs, "2.26.2") 
		lambda{ config_handler.setup }.should raise_error(Trackman::SetupException, "cannot find trackman configuration, make sure trackman addon is installed")
	end

	it "should raise an error if trackman version is bad" do
		config_handler = ConfigurationHandler.new(@configs, "2.22.2") 
		lambda{ config_handler.setup }.should raise_error(Trackman::SetupException, "your heroku version is too low, we recommend '~> 2.26' at least")
	end

	it "should backup configs when they already exist and add the new ones" do
		configs = {"TRACKMAN_MAINTENANCE_PAGE_URL" => "\"en_US.UTF-8\"",
								"TRACKMAN_URL" => "\"url\"",
								"TRACKMAN_ERROR_PAGE_URL" => "\"error_page_url\"",
								"MAINTENANCE_PAGE_URL" => "\"en_US.UTF-8_old\"",
								"SOME_CONFIG" => "\"url\"",
								"ERROR_PAGE_URL" => "\"error_page_url_old\""
							}
		config_handler = ConfigurationHandler.new(configs, "2.26.2")
		config_handler.setup
		config_hash = config_handler.configs

		puts config_hash

		config_hash["ERROR_PAGE_URL.bkp"].should == "\"error_page_url_old\""
		config_hash["MAINTENANCE_PAGE_URL.bkp"].should == "\"en_US.UTF-8_old\""
		config_hash["ERROR_PAGE_URL"].should == "\"error_page_url\""
		config_hash["MAINTENANCE_PAGE_URL"].should == "\"en_US.UTF-8\""
	end

	it "should not backup configs when they do not exist" do
		configs = {"TRACKMAN_MAINTENANCE_PAGE_URL" => "\"en_US.UTF-8\"",
								"TRACKMAN_URL" => "\"url\"",
								"TRACKMAN_ERROR_PAGE_URL" => "\"error_page_url\"",
								"SOME_CONFIG" => "\"url\""
							}
		config_handler= ConfigurationHandler.new(configs, "2.26.2")

		config_handler.setup
		config_hash = config_handler.configs

		config_hash.keys.should_not include("ERROR_PAGE_URL.bkp")
		config_hash.keys.should_not include("MAINTENANCE_PAGE_URL.bkp")
		config_hash["ERROR_PAGE_URL"].should == "\"error_page_url\""
		config_hash["MAINTENANCE_PAGE_URL"].should ==  "\"en_US.UTF-8\""
	end
end