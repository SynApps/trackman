require 'spec_helper'

describe Trackman::Assets::Components::AssetFactory do
  class TestFactory
    extend Trackman::Assets::Components::AssetFactory
  end
  
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
    Object.send(:remove_const, :Rails)
  end

  it "returns an HtmlAsset" do
    asset = TestFactory.create(:path => 'spec/test_data/sample.html')
    
    asset.should be_a_kind_of HtmlAsset
  end

  it "returns a Rails32Asset when we are on rails 3.2" do
    module Rails
      module VERSION
        STRING = "3.2"
      end
    end

    TestFactory.uses_rails32?.should be_true
  end

  it "returns a Rails32Asset when we are on rails 3.2.x" do
    module Rails
      module VERSION
        STRING = "3.2.x"
      end
    end

    TestFactory.uses_rails32?.should be_true
  end

  it "returns a Rails32Asset when we are on rails 3.1.5" do
    module Rails
      module VERSION
        STRING = "3.1.5"
      end
    end

    TestFactory.uses_rails32?.should be_true
  end

  it "returns a normal asset when we are on rails 3.0.9 and below" do
    module Rails
      module VERSION
        STRING = "3.0.9"
      end
    end

    TestFactory.uses_rails32?.should be_false
  end

  it "returns a CssAsset extended with a Rails32Asset when we are on rails 3.2 and the asset is a css one" do
    module Rails
      module VERSION
        STRING = "3.2.0"
      end
    end

    asset = TestFactory.create(:path => 'assets/a.css')
    asset.should be_a_kind_of CssAsset
    TestFactory.uses_rails32?.should be_true
  end

end