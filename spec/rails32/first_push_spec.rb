require 'spec_helper'
require 'helpers/app_creator'
require 'helpers/fakable_pathman_tester'

describe 'first push' do
  before :all do
    FakablePathManTester.switch_on 'spec/fixtures/rails32/clean-install/'
  end
  before :each do
    AppCreator.create
  end

  after :all do
    AppCreator.reset
    FakablePathManTester.switch_off
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
    FakablePathManTester.switch_on 'spec/fixtures/rails32/happy-path/'
  end
  before :each do
    AppCreator.create
  end

  after :all do
    AppCreator.reset
    FakablePathManTester.switch_off
  end

  it "replaces the default templates by the assets" do
    expected = Asset.all
    Asset.sync
    
    actual = RemoteAsset.all
    
    actual.should == expected
  end
end

describe 'full path' do
  before :all do
    FakablePathManTester.switch_on 'spec/fixtures/rails32/fully-loaded/'
    ActLikeRails32.switch_on
  end
  before :each do
    AppCreator.create
  end

  after :all do
    AppCreator.reset
    FakablePathManTester.switch_off
    ActLikeRails32.switch_off
  end

  #right now it doesn't work
  it "replaces all images" do
   expected = Asset.all
   puts expected.map{|x| x.path.to_s }
   Asset.sync
   actual = RemoteAsset.all

   actual.count.should == 7
   actual.should == expected
  end
end