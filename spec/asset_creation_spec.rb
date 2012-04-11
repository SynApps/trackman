require 'spec_helper'

describe Trackman::Assets::Asset, 'create' do
  Asset = Trackman::Assets::Asset
  HtmlAsset = Trackman::Assets::HtmlAsset
  Rails32Asset = Trackman::Assets::Rails32Asset

  before :all do
    class Trackman::Assets::Asset
      def validate_path?
        false
      end
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
    asset = Asset.create(:path => 'spec/test_data/sample.html')
    asset.should be_an_instance_of HtmlAsset
  end

  it "returns a Rails32Asset when we are on rails 3.2" do
    module Rails
      module VERSION
        STRING = "3.2"
      end
    end

    asset = Asset.create(:path => 'assets/a.js')
    asset.should be_an_instance_of Rails32Asset
  end

  it "returns a Rails32Asset when we are on rails 3.2.x" do
    module Rails
      module VERSION
        STRING = "3.2.x"
      end
    end

    asset = Asset.create(:path => 'assets/a.js')
    asset.should be_an_instance_of Rails32Asset
  end

  it "returns a Rails32Asset when we are on rails 3.1.5" do
    module Rails
      module VERSION
        STRING = "3.1.5"
      end
    end

    asset = Asset.create(:path => 'assets/a.js')
    asset.should be_an_instance_of Rails32Asset
  end

  it "returns a Rails32Asset when we are on rails 3.0.9" do
    module Rails
      module VERSION
        STRING = "3.0.9"
      end
    end

    asset = Asset.create(:path => 'assets/a.js')
    asset.should be_an_instance_of Asset
  end
end