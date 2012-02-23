require 'spec_helper'
require 'bombero_client'
describe BomberoClient::Assets::RemoteAsset do
  RemoteAsset = BomberoClient::Assets::RemoteAsset
  it "creates assets on the server" do
    expected = RemoteAsset.new(:path => 'spec/test_data/test2.png')
    expected.create!
    
    actual = RemoteAsset.find expected.id

    actual.should eq(expected)
  end
end