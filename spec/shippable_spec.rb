require 'spec_helper'

describe Trackman::Assets::Shippable do
  class Test
    extend Trackman::Assets::Shippable

    @@events = []
    def self.events
      @@events
    end
    def self.created?
      @@events.any?{|h| h.has_key? :create }
    end
    def self.updated?
      @@events.any?{|h| h.has_key? :update }
    end
    def self.deleted?
      @@events.any?{|h| h.has_key? :delete }
    end

    def self.created(value)
      @@events << { :create => value }
    end

    def self.updated(value)
      @@events << { :update => value }
    end
    
    def self.deleted(value)
      @@events << { :delete => value }
    end
    
    def Test.build_proc symbol, instance 
      case symbol
      when :update
        proc = Proc.new { self.updated instance }
      when :create
        proc = Proc.new { self.created instance }
      when :delete
        proc = Proc.new { self.deleted instance }
      else
        raise 'zomg'
      end
      proc
    end
  end

  before :each do
    Test.events.clear
  end
  
  it "ships the create" do
    diff = {:create => ["test"], :update => [], :delete => []}
    
    Test.ship diff

    Test.created?.should be_true
    Test.deleted?.should be_false
    Test.updated?.should be_false
  end 

  it "ships all of them" do
    diff = {:create => ["test"], :update => ["wassup"], :delete => ["dododo"]}
    
    Test.ship diff

    Test.created?.should be_true
    Test.deleted?.should be_true
    Test.updated?.should be_true
  end

  it "sorts them before execution" do
    diff = {:create => [3], :update => [2], :delete => [1]}
    
    Test.ship diff

    Test.events.map{|x| x.values.first }.should eq([1,2,3])
  end 
end  