require 'spec_helper'
require 'helpers/app_creator.rb'
require 'helpers/act_like_rails32'

describe 'first push' do
  class Asset
    @@pre_path = 'spec/fixtures/rails32'
  end
  
  before :all do
    ActLikeRails32.switch_on
  end
  before :each do
    AppCreator.create
  end

  after :all do
    AppCreator.reset
    ActLikeRails32.switch_off
  end

  it "doesnt do anything on a clean install" do  
    old_assets = RemoteAsset.all

    Asset.sync

    remote_assets = RemoteAsset.all

    old_assets.should == remote_assets
  end
end