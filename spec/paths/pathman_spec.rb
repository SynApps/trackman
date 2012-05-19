require 'spec_helper'

class PathManTester
  extend PathMan
end

describe PathMan do
  it 'gives a path at the same level as the parent if the url is relative and there is no parent specified' do
    parent_url = 'allo/home.html' 
    url = 'bob.jpg'

    actual = PathManTester.translate url, parent_url
    expected = 'allo/bob.jpg'

    actual.should == expected
  end

  it 'absolute url should return a path relative to the root of the app' do
    parent_url = 'allo/home.html'
    url = '/bob.jpg'

    actual = PathManTester.translate url, parent_url
    expected = 'bob.jpg'

    actual.should == expected
  end
  
  it "should throw when the parent_url is absolute" do
    parent_url = '/allo/home.html'
    url = '/bob.jpg'

    lambda{ PathManTester.translate url, parent_url }.should raise_error   
  end
  
  it "should nest on absolute" do
    parent_url = 'allo/home.html'
    url = '/johnny/cash/likes/women/but/not/bob.jpg'

    actual = PathManTester.translate url, parent_url
    expected = 'johnny/cash/likes/women/but/not/bob.jpg'

    actual.should == expected
  end

  it "should nest on relative" do
    parent_url = 'johnny/cash/likes/women/but/not/home.html'
    url = 'wazzo/wazoo/bob.jpg'

    actual = PathManTester.translate url, parent_url
    expected = 'johnny/cash/likes/women/but/not/wazzo/wazoo/bob.jpg'

    actual.should == expected
  end

  it "should handle pathname as strings" do
    parent_url = Pathname.new 'allo/home.html' 
    url = Pathname.new 'bob.jpg'

    actual = PathManTester.translate url, parent_url
    expected = 'allo/bob.jpg'

    actual.should == expected
  end

  # it "works" do
  #   parent_url = Pathname.new 'spec/test_data/all'
  #   url = Pathname.new '2.gif'

  #   actual =  PathManTester.translate url, parent_url
  #   expected = 'spec/test_data/all/2.gif'

  #   actual.should == expected
  # end
end