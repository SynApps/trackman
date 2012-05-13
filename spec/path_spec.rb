require 'spec_helper'
require 'helpers/path_man'

describe 'path manager xx' do
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
end

describe "rails32 the shit out of me, with an image" do
	it "serves an image linked by an html" do
		parent_url = 'public/503.html'
		url = '/assets/bombero.jpg'

		actual = Rails32PathManTester.translate url, parent_url
		expected = 'app/assets/images/bombero.jpg'

		actual.should == expected
	end

	it "serves a css linked by an html" do
		parent_url = 'public/503.html'
		url = '/assets/bombero.css'

		actual = Rails32PathManTester.translate url, parent_url
		expected = 'app/assets/stylesheets/bombero.css'

		actual.should == expected
	end

	it "serves an image linked in a css" do
		parent_url = 'app/assets/stylesheets/bombero/tralala/trundle.css'
		url = '/assets/image.jpg'

		actual = Rails32PathManTester.translate url, parent_url
		expected = 'app/assets/images/image.jpg'

		actual.should == expected
	end

	it "serves a relative image" do
		parent_url = 'app/assets/stylesheets/trundle.css'
		url = 'image.jpg'

		actual = Rails32PathManTester.translate url, parent_url
		expected = 'app/assets/images/image.jpg'

		actual.should == expected
	end

	it "serves a favicon" do
		parent_url = 'public/503.html'
		url = '/favicon.png'

		actual = Rails32PathManTester.translate url, parent_url
		expected = 'public/favicon.png'

		actual.should == expected
	end



	it "weird the path out of me" do
		parent_url = 'app/assets/stylesheets/a/css.css'
		url = '3/32/allo.png'

		actual = Rails32PathManTester.translate url, parent_url
		expected = 'app/assets/images/3/32/allo.png'

		actual.should == expected
	end
end


describe "Fakable paths" do
	before :all do
    FakablePathManTester.switch_on 'spec/fixtures/rails32/clean_path/'
  end

  after :all do
    FakablePathManTester.switch_off
  end

	it "should have a root anywhere for favicons" do
		module PathMan
			alias old_working_dir working_dir

			def prepath 
				'spec/fixtures/rails32/clean_path/'
			end
		end

		parent_url = 'spec/fixtures/rails32/clean_path/app/assets/stylesheets/trundle.css'
		url = 'image.jpg'

		actual = FakablePathManTester.translate url, parent_url
		expected = 'spec/fixtures/rails32/clean_path/app/assets/images/image.jpg'

		actual.should == expected
	end

	it "should have a root anywhere for linked images" do
		parent_url = 'spec/fixtures/rails32/clean_path/public/503.html'
		url = '/favicon.png'

		actual = FakablePathManTester.translate url, parent_url
		expected = 'spec/fixtures/rails32/clean_path/public/favicon.png'

		actual.should == expected
	end
end

#helpers
module PathMan
	alias :old_prepath :prepath
end

class FakablePathManTester
	extend Rails32PathMan

	def self.switch_on prepath
		PathMan.module_eval do
		  define_method :prepath do
		    prepath
		  end
		end
	end

	def self.switch_off
	  PathMan.module_eval do
		  define_method :prepath do
		    old_prepath
		  end
		end
	end
end

class PathManTester
	extend PathMan
end

class Rails32PathManTester
	extend Rails32PathMan
end