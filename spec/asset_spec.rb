require 'spec_helper'
require 'digest/md5'

describe Trackman::Assets::Asset do
  
  Asset = Trackman::Assets::Asset 
  RemoteAsset = Trackman::Assets::RemoteAsset 
  it "should raise an exception if the path is not good" do 
    wrong_path = "./wrong_path.html"
    lambda { Asset.new(:path => wrong_path) }.should raise_error Trackman::Assets::AssetNotFoundError
  end

  it "is equal if the path is the same" do
    path = "./spec/spec_helper.rb"

    asset1 = Asset.new(:path => path)
    asset2 = Asset.new(:path => path)

    asset1.should == asset2
  end
  

  it "is equal if the path points to the same place" do
    path1 = "spec/spec_helper.rb"
    path2 = "spec/../spec/spec_helper.rb"
    
    asset1 = Asset.new(:path => path1)
    asset2 = Asset.new(:path => path2)

    asset1.should == asset2
  end
  
  describe "#data" do
    it "returns content of the file specified by path" do
      path = "./spec/spec_helper.rb"
      asset = Asset.new(:path => path)
      
      asset.data.should eq(File.open(path).read)    
    end
  end
  
  describe "#hash" do
    it "returns the fingerprint of data" do
      path = "./spec/spec_helper.rb"
      asset = Asset.new(:path => path)
        
      file = File.open path
      asset.hash.should eq(Digest::MD5.hexdigest(file.read))
    end
  end
  
  

  describe "#remote" do
    it "returns a remote asset equal to the previous one" do
      local = Asset.maintenance_page
      remote = local.to_remote
      
      local.should eq(remote)
      remote.is_a?(RemoteAsset).should be_true
    end  
  end

  it "compares html higher than any other asset" do
    asset1 = Asset.create(:path => 'spec/test_data/sample.html')
    asset2 = Asset.create(:path => 'spec/test_data/test1.jpeg')

    (asset1 <=> asset2).should == 1
    (asset2 <=> asset1).should == -1
  end

  it "compares html equal to any other html asset" do
    asset1 = Asset.create(:path => 'spec/test_data/sample.html')
    asset2 = Asset.create(:path => 'spec/test_data/sample.html')

    (asset1 <=> asset2).should == 0
  end
end