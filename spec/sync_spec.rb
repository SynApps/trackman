require 'spec_helper'

describe Trackman::Assets::Asset do
  before :each do
    @@called = false
  end
  after :each do
    ENV['TRACKMAN_AUTOSYNC'] = nil
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

  it "doesn't blow up when I autosync even though something is broken" do
    def Asset.sync
      @@called = true
      raise "something is wrong"
    end
    result = true
    
    lambda { result = Asset.autosync }.should_not raise_error
    
    result.should be_false
    @@called.should be_true
  end
end