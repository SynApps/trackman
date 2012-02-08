require 'bombero_client'

describe BomberoClient::Assets::HtmlAsset do
  Asset = BomberoClient::Assets::Asset
  
  it "should contains every image within the html as assets" do
    asset = Asset.create('spec/test_data/sample.html')

    expected = [Asset.create('spec/test_data/test1.jpeg'), Asset.create('spec/test_data/test2.png'), Asset.create('./spec/test_data/test3.gif')]
    
    asset.images.size.should eq(3)
    asset.images.should eq(expected)
  end  

   
  it "should contains every js within the html as assets" do
    asset = Asset.create('spec/test_data/sample.html')

    expected = ['a', 'b', 'c'].collect{|x| Asset.create("spec/test_data/#{x}.js") }.to_a 
    
    asset.javascripts.size.should eq(3)
    asset.javascripts.should eq(expected)
  end
  
  it "should contains every css within the html as assets" do
    asset = Asset.create('spec/test_data/sample.html')

    expected = ['y', 'z'].collect{|x| Asset.create("spec/test_data/#{x}.css") }.to_a 
    
    asset.stylesheets.size.should eq(2)
    asset.stylesheets.should eq(expected)
  end
    
end