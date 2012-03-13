require 'spec_helper'

describe TrackmanClient::Assets::Diffable do
  RemoteAsset = TrackmanClient::Assets::RemoteAsset 
  
  class TestDiff
    extend TrackmanClient::Assets::Diffable
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
end