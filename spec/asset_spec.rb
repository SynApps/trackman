require 'spec_helper'
require 'digest/md5'

describe Trackman::Assets::Asset do
  it "should raise an exception if the path is not good" do 
    wrong_path = "./wrong_path.html"
    lambda { Asset.new(:path => wrong_path) }.should raise_error Trackman::Errors::AssetNotFoundError
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

  it "is not equal if the virtual path is different" do
    asset1 = RemoteAsset.create(:path => 'same/path', :virtual_path => '/different/virtual/path')
    asset2 = RemoteAsset.create(:path => 'same/path', :virtual_path => 'different/virtual/path')

    asset1.should_not == asset2
  end
  
  describe "#data" do
    it "returns content of the file specified by path" do
      path = "./spec/spec_helper.rb"
      asset = Asset.create(:path => path)
      
      asset.data.should eq(File.open(path).read)    
    end
  end
  
  describe "#hash" do
    it "returns the fingerprint of data" do
      path = "./spec/spec_helper.rb"
      asset = Asset.create(:path => path)
        
      file = File.open path
      asset.file_hash.should eq(Digest::MD5.hexdigest(file.read))
    end
  end
  
  describe "#remote" do
    
    class TestAsset < Asset
      def self.maintenance_page
        Asset.create(:path => 'spec/test_data/sample.html')
      end
    end

    it "returns a remote asset equal to the previous one" do
      local = TestAsset.maintenance_page
      
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

  it "compares two htmls by their path" do
    asset1 = Asset.create(:path => 'spec/test_data/all/all.html')
    asset2 = Asset.create(:path => 'spec/test_data/all/all2.html')

    (asset1 <=> asset2).should == -1
  end


  it "compares a css asset higher than its dependencies" do
    dependent = Asset.create(:path => 'spec/test_data/css/with-asset.css')
    dependency = dependent.assets.first

    (dependent <=> dependency).should == 1
    (dependency <=> dependent).should == -1
  end

  it "fixes the bug with realpath" do
    class MyAsset < Asset
      def validate_path?
        false
      end
      def file_hash
        123
      end
    end

    local = MyAsset.new(:path => 'public/test.html')
    remote = MyAsset.new(:path => 'public/./test.html')

    local.should == remote
  end
end