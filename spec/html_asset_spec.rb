require 'spec_helper'

describe Trackman::Assets::HtmlAsset do  
  it "should contains every image within the html as assets" do
    asset = Asset.create(:path => 'spec/test_data/sample.html')

    expected = [
      Asset.create(:path => 'spec/test_data/test1.jpeg', :virtual_path => 'test1.jpeg'),
      Asset.create(:path => 'spec/test_data/test2.png', :virtual_path => 'test2.png'),
      Asset.create(:path => 'spec/test_data/test3.gif', :virtual_path => 'test3.gif')
    ]
    
    actual = asset.assets.select{|a| !(['.css', '.js'].include?(a.path.extname)) }

    actual.should eq(expected)
  end  

   
  it "should contains every js within the html as assets" do
    asset = Asset.create(:path => 'spec/test_data/sample.html')

    expected = ['a', 'b', 'c'].map{|x| Asset.create(:path =>"spec/test_data/#{x}.js", :virtual_path => "#{x}.js") } 
      
    actual = asset.assets.select{|a| a.path.extname == '.js'}

    actual.should eq(expected)
  end
  
  it "should contains every css within the html as assets" do
    asset = Asset.create(:path => 'spec/test_data/sample.html')

    expected = ['y', 'z'].map{|x| Asset.create(:path => "spec/test_data/#{x}.css", :virtual_path => "#{x}.css") } 
    
    actual = asset.assets.select{|a| a.path.extname == '.css'}

    actual.should eq(expected)
  end

  it "returns all recursive css imports and images under the html file that contains css" do
    expected = [
        CssAsset.new(:path => 'spec/test_data/css/recursive/imported-lvl2.css', :virtual_path => "imported-lvl2.css"),
        CssAsset.new(:path => 'spec/test_data/css/recursive/imported-lvl3.css', :virtual_path => "imported-lvl3.css"),
        Asset.new(:path => 'spec/test_data/css/recursive/riding-you.jpg', :virtual_path => "riding-you.jpg")
      ]
    asset = Asset.create(:path => 'spec/test_data/css/recursive/html-with-css.html')

    actual = asset.assets

    actual.should == expected
  end

  it "removes the query string from the path" do
    asset = Asset.create(:path => 'spec/fixtures/composite_assets/query_string_in_path.html')
    expected = [
      '/assets/burndownchartslogo.png', '/assets/google.png', '/assets/facebook.png', 
      '/assets/twitter.png', '/assets/favicon.png', '/assets/application.js', '/assets/application.css'
    ]

    actual = asset.children_paths
    
    actual.should == expected
  end

  it "does not return assets in comments" do
    asset = Asset.create(:path => 'spec/test_data/html/comments.html')
    expected = []

    actual = asset.children_paths
    
    actual.should == expected
  end

  it "returns all link tags" do
    asset = Asset.create(:path => 'spec/test_data/html/favicon.html')
    expected = ['assets/trackman70x70.png', '/assets/application.css']

    actual = asset.children_paths
    
    actual.should == expected
  end
end