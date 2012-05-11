require 'spec_helper'

class FakeCompositeAsset 
  #include CompositeAsset
end

describe FakeCompositeAsset do
  it "" do
    asset = CssAsset.new(:path => 'spec/test_data/css/with-asset.css')
    asset.assets.should == [CssAsset.new(:path => 'spec/test_data/css/imported.css')] 
  end
end