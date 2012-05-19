require 'spec_helper'
require 'helpers/fakable_pathman_tester'

class Tester
  extend Rails32PathMan
end

describe FakablePathManTester do
  before :all do
    FakablePathManTester.switch_on 'spec/fixtures/rails32/clean_path/'
  end

  after :all do
    FakablePathManTester.switch_off
  end

  it "should have a root anywhere for favicons" do
    parent_url = 'spec/fixtures/rails32/clean_path/app/assets/stylesheets/trundle.css'
    url = 'image.jpg'
    
    actual = Tester.translate url, parent_url
    expected = 'spec/fixtures/rails32/clean_path/app/assets/images/image.jpg'

    actual.should == expected
  end

  it "should have a root anywhere for linked images" do
    parent_url = 'spec/fixtures/rails32/clean_path/public/503.html'
    url = '/favicon.png'

    actual = Tester.translate url, parent_url
    expected = 'spec/fixtures/rails32/clean_path/public/favicon.png'

    actual.should == expected
  end
end