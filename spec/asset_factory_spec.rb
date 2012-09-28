require 'spec_helper'

describe Trackman::Assets::AssetFactory do
  class TestFactory
    extend Trackman::Assets::AssetFactory
  end
  
  before :all do
    class Trackman::Assets::Asset
      def validate_path?
        false
      end
    end
  end  
  after :each do
    begin
      Object.send(:remove_const, :Rails)
    rescue
    end
  end
  after :all do
    class Trackman::Assets::Asset
      def validate_path?
        true
      end
    end
  end

  it "returns an HtmlAsset" do
    asset = TestFactory.create(:path => 'spec/test_data/sample.html')
    
    asset.should be_a_kind_of HtmlAsset
  end


  it "returns a Rails32 when asset pipeline is configured to be used" do  
    module Rails
      def self.application
        Rails::App.new
      end
      
      class App
        def assets
          Rails::Assets.new
        end
        def config
          Rails::Config.new
        end
      end

      class Config
        def assets
          Rails::Assets.new
        end 
      end

      class Assets
        def enabled
          true
        end
      end
    end
    
    TestFactory.asset_pipeline_enabled?.should be_true
  end

  it "returns a normal asset if asset pipepeline is not defined or not used" do

    TestFactory.asset_pipeline_enabled?.should be_false
    asset = TestFactory.create(:path => 'x.css')
    asset.should_not be_a_kind_of Rails32Resolver 
  end
end