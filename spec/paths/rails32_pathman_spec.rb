require 'spec_helper'

class Rails32Tester
  extend Rails32PathResolver
end


describe Rails32PathResolver do
  it "serves an image linked by an html" do
    parent_url = 'public/503.html'
    url = '/assets/bombero.jpg'

    actual = Rails32Tester.translate url, parent_url
    expected = 'app/assets/images/bombero.jpg'

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
    parent_url = 'app/assets/stylesheets/trundle.css'
    url = 'image.jpg'

    actual = Rails32Tester.translate url, parent_url
    expected = 'app/assets/images/image.jpg'

    actual.should == expected
  end

  it "serves a favicon" do
    parent_url = 'public/503.html'
    url = '/favicon.png'

    actual = Rails32Tester.translate url, parent_url
    expected = 'public/favicon.png'

    actual.should == expected
  end



  it "works for nested paths" do
    parent_url = 'app/assets/stylesheets/a/css.css'
    url = '3/32/allo.png'

    actual = Rails32Tester.translate url, parent_url
    expected = 'app/assets/images/3/32/allo.png'

    actual.should == expected
  end
end