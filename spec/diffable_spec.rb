require 'spec_helper'

describe Trackman::Assets::Components::Diffable do
  Asset = Trackman::Assets::Asset 
  RemoteAsset = Trackman::Assets::RemoteAsset 
  
  class TestDiff
    extend Trackman::Assets::Components::Diffable
  end
 
  it "specify the html to update and the image to delete" do    
    expected = { 
      :create => [], 
      :update => [Asset.create(:path => 'spec/test_data/sample.html')], 
      :delete => [ Asset.create(:path => 'spec/test_data/test1.jpeg')]
    }
    
    remote = [
      RemoteAsset.new(:path => 'spec/test_data/sample.html', :file_hash => 'abcd123'), 
      RemoteAsset.new(:path => 'spec/test_data/test1.jpeg', :file_hash => '12345')
    ]
    
    local = [Asset.create(:path => 'spec/test_data/sample.html')]

    actual = TestDiff.diff local, remote
    
    actual.should eq(expected)
  end

  it "returns the file to create if it is missing remotely" do
    expected = { 
      :create => [Asset.create(:path => 'spec/test_data/test1.jpeg')], 
      :update => [], 
      :delete => []
    }

    html_asset = Asset.create(:path => 'spec/test_data/sample.html')
    remote = [html_asset]
    local = [html_asset, Asset.create(:path => 'spec/test_data/test1.jpeg')]

    actual = TestDiff.diff local, remote

    actual.should eq(expected)
  end

  it "can not mark html remotes as deleted" do
    expected = { 
      :create => [], 
      :update => [], 
      :delete => []
    }

    asset1 = RemoteAsset.create(:path => 'spec/test_data/sample.html')
    asset2 = RemoteAsset.create(:path => 'spec/test_data/external_paths/1.html')

    actual = TestDiff.diff([], [asset1, asset2])

    actual.should eq(expected)
  end
end