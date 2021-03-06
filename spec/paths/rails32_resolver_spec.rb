require 'spec_helper'
require 'sprockets'

class Rails32Tester
  extend Rails32Resolver

  def self.working_dir
    Pathname.new('spec/fixtures/sprockets')
  end
end


describe Rails32Resolver do
  before :all do
    module Resolver
      alias old_exist file_exist?
      def file_exist? path
        true
      end
    end
  end

  after :all do
    module Resolver
      alias file_exist? old_exist
    end
  end
  
  it "serves an image linked by an html" do
    parent_url = 'public/503.html'
    url = '/assets/bombero.jpeg'

    actual = Rails32Tester.translate url, parent_url
    expected = 'app/assets/images/bombero.jpeg'

    actual.should == expected
  end

  it "serves a css linked by an html" do
    parent_url = 'public/503.html'
    url = '/assets/bombero.css'

    actual = Rails32Tester.translate url, parent_url
    expected = 'app/assets/stylesheets/bombero.css'

    actual.should == expected
  end

  it "serves an image linked in a css" do
    parent_url = 'app/assets/stylesheets/bombero/tralala/trundle.css'
    url = '/assets/image.jpg'

    actual = Rails32Tester.translate url, parent_url
    expected = 'app/assets/images/image.jpg'

    actual.should == expected
  end

  it "serves a relative image" do
    parent_url = 'app/assets/stylesheets/bombero/tralala/trundle.css'
    url = 'img.jpg'

    actual = Rails32Tester.translate url, parent_url
    expected = 'app/assets/images/bombero/tralala/img.jpg'

    actual.should == expected
  end

  it "works for nested paths" do
    parent_url = 'app/assets/stylesheets/a/css.css'
    url = '3/32/allo.png'

    actual = Rails32Tester.translate url, parent_url
    expected = 'app/assets/images/a/3/32/allo.png'

    actual.should == expected
  end

  it "works for nested paths with assets/img.png" do
    parent_url = 'app/assets/stylesheets/css.css'
    url = 'assets/img.png'

    actual = Rails32Tester.translate url, parent_url
    expected = 'app/assets/images/img.png'

    actual.should == expected
  end

  it "serves a favicon" do
    parent_url = 'public/503.html'
    url = '/favicon.png'

    actual = Rails32Tester.translate url, parent_url
    expected = 'public/favicon.png'

    actual.should == expected
  end

  it "public is not buggy" do
    parent_url = 'public/500.html'
    url = 'assets/assets/rails.png'

    actual = Rails32Tester.translate url, parent_url
    expected = 'public/assets/rails.png'

    actual.should == expected
  end

  it "public is not buggy 2" do
    parent_url = 'public/500.html'
    url = 'assets/img.png'

    actual = Rails32Tester.translate url, parent_url
    expected = 'app/assets/images/img.png'

    actual.should == expected
  end

  it "can find this image" do
    parent_url = 'public/503.html'
    url = 'assets/trackman70x70.png'

    actual = Rails32Tester.translate url, parent_url
    expected = 'app/assets/images/trackman70x70.png'

    actual.should == expected
  end

  it "can find a normal absolute path" do
    parent_url = 'public/503.html'
    url = '/assets/trackman70x70.png'

    actual = Rails32Tester.translate url, parent_url
    expected = 'app/assets/images/trackman70x70.png'

    actual.should == expected
  end
end
