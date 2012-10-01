require 'spec_helper'


module Trackman
  module Utility
    class Debugger
      def self.send_data data
        data
      end
    end
  end
end
describe Trackman::Utility::Debugger do
  before :all do
    module Trackman
      module Assets
        class RemoteAsset
          class << self
            alias old_all all
            def all
              []
            end
          end
        end
      end
    end
  end

  after :all do
    module Trackman
      module Assets
        class RemoteAsset
          class << self
            alias all old_all
          end
        end
      end
    end
  end
  
  describe "log_exception" do
    it "returns everything I need" do 
      ex  = Trackman::Errors::ConfigSetupError.new
      
      result = Trackman::Utility::Debugger.log_exception ex
      
      result[:ruby_version].should_not be_nil
      result[:rails_version].should_not be_nil
      result[:gem_version].should_not be_nil
      result[:local].should == []
      result[:remote].should == []
      result[:exception][:class].should == "Trackman::Errors::ConfigSetupError"
      result[:exception][:message].should == ex.message
      result[:exception][:backtrace].should == ex.backtrace
    end
  end
end