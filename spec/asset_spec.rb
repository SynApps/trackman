require 'spec_helper'
require 'bombero_client'
require 'digest/md5'

describe BomberoClient::Assets::Asset do
  
  Asset = BomberoClient::Assets::Asset 
  it "should raise an exception if the path is not good" do 
    wrong_path = "./wrong_path.html"
    lambda { Asset.new(:path => wrong_path) }.should raise_error BomberoClient::Assets::AssetNotFoundError
  end

  it "should be equal if the path is the same" do
    path = "./spec/spec_helper.rb"

    asset1 = Asset.new(:path => path)
    asset2 = Asset.new(:path => path)

    asset1.should == asset2
  end
  
  it "should be equal if the path points to the same place" do
    path1 = "spec/spec_helper.rb"
    path2 = "../bombero-client/spec/spec_helper.rb"
    
    asset1 = Asset.new(:path => path1)
    asset2 = Asset.new(:path => path2)

    asset1.should == asset2
  end
  
  it "should return the data" do
    path = "./spec/spec_helper.rb"
    asset = Asset.new(:path => path)
    
    asset.data.should eq(File.open(path).read)    
  end
  
  it "should return the hash" do
    path = "./spec/spec_helper.rb"
    asset = Asset.new(:path => path)
      
    file = File.open path
    asset.hash.should eq(Digest::MD5.hexdigest(file.read))
  end

  it "all should return every asset for a given maintenance path" do
    class Asset
      def self.maintenance_page
        Asset.create(:path => 'spec/test_data/all/all.html')
      end 
      def self.maintenance_path
        Pathname.new('spec/test_data/all/all.html')
      end
    end 

    expected = [Asset.maintenance_page, Asset.create(:path => 'spec/test_data/all/1.css'), Asset.create(:path => 'spec/test_data/all/2.gif') ]
    actual = Asset.all
    
    actual.should eq(expected)
  end

  it "all should include assets from error page if it is also specified" do
    class Asset
      def self.maintenance_page
        Asset.create(:path => 'spec/test_data/all/all.html')
      end
      def self.error_page
        Asset.create(:path => 'spec/test_data/all/all2.html')
      end 

      def self.maintenance_path
        Pathname.new('spec/test_data/all/all.html')
      end
      def self.error_path
        Pathname.new('spec/test_data/all/all2.html')
      end 
    end 

    expected = [ Asset.maintenance_page, 
      Asset.create(:path => 'spec/test_data/all/1.css'), 
      Asset.create(:path => 'spec/test_data/all/2.gif'), 
      Asset.error_page, 
      Asset.create(:path => 'spec/test_data/all/3.js') 
    ]

    actual = Asset.all
    
    actual.should eq(expected)
  end

  it "all should not include the same asset twice" do
    class Asset
      def self.maintenance_page
        Asset.create(:path => 'spec/test_data/all/all.html')
      end
      def self.error_page
        Asset.create(:path => 'spec/test_data/all/all3.html')
      end
      def self.maintenance_path
        Pathname.new('spec/test_data/all/all.html')
      end
      def self.error_path
        Pathname.new('spec/test_data/all/all3.html')
      end  
    end 

    expected = [Asset.maintenance_page, 
      Asset.create(:path => 'spec/test_data/all/1.css'), 
      Asset.create(:path => 'spec/test_data/all/2.gif'), 
      Asset.error_page
    ]
    
    actual = Asset.all
    
    actual.should eq(expected)
  end

  it "all should not only include assets that are external to the app" do
    class Asset
      def self.maintenance_page
        Asset.create(:path => 'spec/test_data/external_paths/1.html')
      end
      def self.error_page
        Asset.create(:path => '/invalid/path')
      end
      def self.maintenance_path
        Pathname.new('spec/test_data/external_paths/1.html')
      end 
      def self.error_path
        Pathname.new('/invalid/path')
      end  
    end 

    expected = [Asset.maintenance_page, Asset.create(:path => 'spec/test_data/external_paths/1.css')]
    
    actual = Asset.all
    
    actual.should eq(expected)
  end
end