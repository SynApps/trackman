require 'spec_helper'

describe Trackman::Assets::Asset do
  Asset = Trackman::Assets::Asset
  
  before :each do
    @@called = false
  end
  
  it "syncs without any special config" do
    def Asset.sync
      @@called = true
    end
    
    Asset.autosync

    @@called.should be_true
  end  
  
  it "doesnt autosync if ENV is set to false/0/FALSE" do
    def Asset.sync
      @@called = true
    end
    
    ['false', '0', 'FALSE'].each do |v|
      ENV['TRACKMAN_AUTOSYNC'] = v
      Asset.autosync
    end
     
    @@called.should be_false
  end
end