require 'spec_helper'
require 'bombero_client'
describe BomberoClient::Assets::RemoteAsset do
  RemoteAsset = BomberoClient::Assets::RemoteAsset
  
  after :each do
    RemoteAsset.all.each do |a|
      a.delete
    end
  end  

  it "creates assets on the server" do
    expected = RemoteAsset.new(:path => 'spec/test_data/test2.png')
    expected.create!
    
    actual = RemoteAsset.find expected.id

    actual.should eq(expected)
  end

  it "deletes assets on the server" do
    expected = RemoteAsset.new(:path => 'spec/test_data/y.css')
    expected.create!
    
    expected.delete
    
    lambda { RemoteAsset.find expected.id }.should raise_error(RestClient::ResourceNotFound)
  end
  
  it "returns all assets on the server" do
    expected = ['/public/503-error.html', '/public/503.html', 'spec/test_data/y.css', 'spec/test_data/a.js', 'spec/test_data/sample.html']
    assets = expected.map { |f| RemoteAsset.new(:path => f) }.to_a

    assets.drop(2).each{|f| f.create! }

    RemoteAsset.all.map{|a| a.path.to_s }.should eq(expected)
  end  
end