require 'spec_helper'
require 'helpers/app_creator.rb'
require 'helpers/act_like_rails32'

describe 'first push' do
  before :all do
    ActLikeRails32.switch_on 'spec/fixtures/rails32/clean-install'
  end
  before :each do
    AppCreator.create
  end

  after :all do
    AppCreator.reset
    ActLikeRails32.switch_off
  end

  it "does not do anything on a clean install" do  
    expected = RemoteAsset.all

    Asset.sync

    actual = RemoteAsset.all

    actual.should == expected
  end
end

describe 'happy path' do
  before :all do
    ActLikeRails32.switch_on 'spec/fixtures/rails32/happy-path'
  end
  before :each do
    AppCreator.create
  end

  after :all do
    AppCreator.reset
    ActLikeRails32.switch_off
  end

  it "replaces the default templates by the assets" do
    expected = Asset.all
    
    Asset.sync
    
    actual = RemoteAsset.all
    
    actual.should == expected
  end
end