require 'spec_helper'

describe Trackman::Assets::Asset do
  
  class MyTestAsset < Asset
  end

  before :each do
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
    MyTestAsset.should_receive(:sync)

    MyTestAsset.autosync
  end  
  
  it "doesnt autosync if ENV is set to false/0/FALSE" do
    MyTestAsset.should_not_receive(:sync)

    ['false', '0', 'FALSE'].each do |v|
      ENV['TRACKMAN_AUTOSYNC'] = v
      MyTestAsset.autosync
    end
  end
  
  it "doesn't autosync if the env is dev or test" do
    class Rails
      def self.env
        Env.new
      end  
    end
    
    class Env
      def production?
        false
      end
      def development?
        true
      end
      def test?
        false
      end
    end
    MyTestAsset.should_not_receive(:sync)

    MyTestAsset.autosync
  end
  
  it "doesn't blow up when I autosync even though something is broken" do
    def MyTestAsset.sync
      raise "something is wrong"
    end
    result = true
    MyTestAsset.should_receive(:sync)

    lambda { result = MyTestAsset.autosync }.should_not raise_error
    
    result.should be_false
  end

  it "logs the error when sync is broken" do
    MyTestAsset.stub!(:sync).and_raise("something is wrong")

    RemoteAsset.should_receive(:log_exception).once

    lambda { result = MyTestAsset.autosync }.should_not raise_error
  end
end