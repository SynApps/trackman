require 'spec_helper'
require 'helpers/app_creator'
require 'helpers/fakable_pathman_tester'
require 'helpers/act_like_rails2311'

describe 'full path' do
  before :all do
    FakablePathManTester.switch_on 'spec/fixtures/rails2311/fully-loaded/'
    ActLikeRails2311.switch_on
  end
  before :each do
    AppCreator.create
  end

  after :all do
    AppCreator.reset
    FakablePathManTester.switch_off
    ActLikeRails2311.switch_off
  end

  it "replaces all images" do
   local = Asset.all

   Asset.sync
   remote = RemoteAsset.all
   
   remote.count.should == 8
   local.each{|l| remote.should include(l) }
  end
end