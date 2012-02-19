require 'spec_helper'
require 'bombero_client'

describe BomberoClient::Server do
  RemoteAsset = BomberoClient::Assets::RemoteAsset 
  class TestAsset
    include BomberoClient::Server
   
    def self.remote_assets
      [RemoteAsset.new(:path => 'spec/test_data/sample.html', :hash => 'abcd123'), 
       RemoteAsset.new(:path => 'spec/test_data/test1.jpeg', :hash => '12345')]
    end
    def self.all
      [Asset.create(:path => 'spec/test_data/sample.html')]
    end
  end
 
  it "specify the html to update and the image to delete" do    
    html = Asset.create(:path => 'spec/test_data/sample.html')
    
    expected = { :create => [], 
      :update => [Asset.create(:path => 'spec/test_data/sample.html')], 
      :delete => [ Asset.create(:path => 'spec/test_data/test1.jpeg')]
    }
    
    actual = TestAsset.diff 
    
    [:create, :update, :delete].each do |action|
      actual[action].should eq(expected[action])
    end

  end

end