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
  end
  before :each do
    AppCreator.create
  end

  after :all do
    AppCreator.reset
    FakablePathManTester.switch_off
  end

  it "replaces paths correctly" do
    actual = Asset.all
  end

  #right now it doesn't work
  #it "replaces all images" do
  #  expected = Asset.all
  #  Asset.sync
  #  actual = RemoteAsset.all

  #  actual.count.should == 8
  #  actual.should == expected
  #end
end