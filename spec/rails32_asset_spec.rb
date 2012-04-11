require 'spec_helper'

describe Trackman::Assets::Rails32Asset do
  Rails32Asset = Trackman::Assets::Rails32Asset
  
  before :all do
    class Trackman::Assets::Rails32Asset
      def validate_path?
        false
      end
    end
  end  
  after :all do
    class Trackman::Assets::Rails32Asset
      def validate_path?
        true
      end
    end
  end

  it "should transform the path for an image" do
    expected = 'app/assets/images/img.png'
    actual = Rails32Asset.new(:path => 'assets/img.png')

    actual.path.to_s.should == expected
  end

  it "should transform the path when there is a slash at the beginning also" do
    expected = 'app/assets/images/img.png'
    actual = Rails32Asset.new(:path => '/assets/img.png')

    actual.path.to_s.should == expected
  end

  it "should transform the path for a js" do
    expected = 'app/assets/javascripts/test.js'
    actual = Rails32Asset.new(:path => 'assets/test.js')

    actual.path.to_s.should == expected
  end

  it "should transform the path for a css" do
    expected = 'app/assets/stylesheets/blah.css'
    actual = Rails32Asset.new(:path => 'assets/blah.css')

    actual.path.to_s.should == expected
  end

  it "should not do anything if the path is already local" do
    expected = 'app/assets/stylesheets/blah.css'
    actual = Rails32Asset.new(:path => 'app/assets/stylesheets/blah.css')

    actual.path.to_s.should == expected
  end

   it "should remove slash at the beginning even for local paths" do
    expected = 'app/assets/stylesheets/blah.css'
    actual = Rails32Asset.new(:path => '/app/assets/stylesheets/blah.css')

    actual.path.to_s.should == expected
  end
end