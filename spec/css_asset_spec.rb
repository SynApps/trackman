require 'spec_helper'

describe CssAsset do
  it "returns its assets when it has import in it" do
    asset = Asset.create(:path => 'spec/test_data/css/with-asset.css')
    
    asset.assets.should == [Asset.create(:path => 'spec/test_data/css/imported.css', :virtual_path => 'imported.css')] 
  end

  it "returns multiple assets when it has multiple imports" do
    actual = Asset.create(:path => 'spec/test_data/css/with-multiple-assets.css')
    expected = [
      Asset.create(:path => 'spec/test_data/css/imported.css', :virtual_path => 'imported.css'), 
      Asset.create(:path => 'spec/test_data/css/imported2.css',  :virtual_path => 'imported2.css')
    ] 

    actual.assets.should == expected
  end

  it "returns an image if it is within the css" do
    actual = Asset.create(:path => 'spec/test_data/css/image/with-image.css')
    expected = [ Asset.create(:path => 'spec/test_data/css/image/riding-you.jpg', :virtual_path => 'riding-you.jpg')] 

    actual.assets.should == expected
  end

  it "returns all recursive css imports and images under the css file" do
    expected = 
      [
        Asset.create(:path => 'spec/test_data/css/recursive/imported-lvl2.css', :virtual_path => 'imported-lvl2.css'),
        Asset.create(:path => 'spec/test_data/css/recursive/imported-lvl3.css', :virtual_path => 'imported-lvl3.css'),
        Asset.create(:path => 'spec/test_data/css/recursive/riding-you.jpg', :virtual_path => 'riding-you.jpg')
      ]
    asset = Asset.create(:path => 'spec/test_data/css/recursive/imported-recursive.css')
    actual = asset.assets

    actual.should == expected
  end

  it "does not return assets in comment" do
    expected = []
    asset = Asset.create(:path => 'spec/test_data/css/comments.css')
    actual = asset.assets

    actual.should == expected
  end
end