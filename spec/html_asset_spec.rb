require 'spec_helper'

describe Trackman::Assets::HtmlAsset do
  Asset = Trackman::Assets::Asset
  
  it "should contains every image within the html as assets" do
    asset = Asset.create(:path => 'spec/test_data/sample.html')

    expected = ['spec/test_data/test1.jpeg', 'spec/test_data/test2.png', 'spec/test_data/test3.gif']
    
    asset.img_paths.should eq(expected)
  end  

   
  it "should contains every js within the html as assets" do
    asset = Asset.create(:path => 'spec/test_data/sample.html')

    expected = ['a', 'b', 'c'].collect{|x| "spec/test_data/#{x}.js" } 
    
    asset.js_paths.should eq(expected)
  end
  
  it "should contains every css within the html as assets" do
    asset = Asset.create(:path => 'spec/test_data/sample.html')

    expected = ['y', 'z'].collect{|x| "spec/test_data/#{x}.css" } 
    
    asset.css_paths.should eq(expected)
  end
end