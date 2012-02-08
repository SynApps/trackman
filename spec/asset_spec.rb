require 'spec_helper'
require 'bombero_client'
require 'digest/md5'

describe BomberoClient::Assets::Asset do
  
  Asset = BomberoClient::Assets::Asset 
  it "should raise an exception if the path is not good" do 
    wrong_path = "./wrong_path.html"
    lambda { Asset.new(wrong_path) }.should raise_error BomberoClient::Assets::AssetNotFoundError
  end

  it "should be equal if the path is the same" do
    path = "./spec/spec_helper.rb"

    asset1 = Asset.new(path)
    asset2 = Asset.new(path)

    asset1.should == asset2
  end
  
  it "should be equal if the path points to the same place" do
    path1 = "spec/spec_helper.rb"
    path2 = "../bombero-client/spec/spec_helper.rb"
    
    asset1 = Asset.new(path1)
    asset2 = Asset.new(path2)

    asset1.should == asset2
  end
  
  it "should return the data as a stream" do
    path = "./spec/spec_helper.rb"
    asset = Asset.new(path)
    
    asset.file.should be_a_kind_of IO
    asset.data.should eq(File.open(path).read)    
  end
  
  it "should return the hash" do
    path = "./spec/spec_helper.rb"
    asset = Asset.new(path)
      
    file = File.open path
    asset.hash.should eq(Digest::MD5.hexdigest(file.read))
  end
end