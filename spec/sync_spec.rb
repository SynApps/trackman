require 'spec_helper'

describe Trackman::Assets::Asset do
  before :all do
    class Asset
      class << self
        alias :old_sync :sync
      end
    end

    def Asset.sync
      @@called = true
    end
  end

  after :all do
    def Asset.sync
      old_sync
    end
  end
  
  before :each do
    @@called = false

    class Env
      def production?
        true
      end
    end
  end

  after :each do
    ENV['TRACKMAN_AUTOSYNC'] = nil
    begin
      Object.send(:remove_const, :Rails)
    rescue
    end
  end
  
  it "syncs without any special config" do
    Asset.autosync

    @@called.should be_true
  end  
  
  it "doesnt autosync if ENV is set to false/0/FALSE" do
    ['false', '0', 'FALSE'].each do |v|
      ENV['TRACKMAN_AUTOSYNC'] = v
      Asset.autosync
    end
     
    @@called.should be_false
  end
  
  it "doesn't autosync if the env is not in production" do
    class Rails
      def self.env
        Env.new
      end  
    end
    
    class Env
      def production?
        false
      end
    end

    Asset.autosync

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