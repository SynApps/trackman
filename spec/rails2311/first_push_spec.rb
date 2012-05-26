require 'spec_helper'
require 'helpers/app_creator'
require 'helpers/fakable_pathman_tester'

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
   expected = Asset.all
   
   Asset.sync
   actual = RemoteAsset.all

   actual.count.should == 8
   actual.should == expected
  end
end