require 'spec_helper'

class TestComposite
  include Trackman::Assets::CompositeAsset
  
  def path 
    'parent'
  end

  def asset_from(virtual, physical)
    TestAsset.new(:virtual_path => virtual.dup, :path => translate(physical, self.path))  
  end
end

class TestAsset < Trackman::Assets::Asset
  def validate_path?
    false
  end    
end

describe Trackman::Assets::CompositeAsset do
  before :each do
    @composite = TestComposite.new
  end
  it "has children" do
    asset = Asset.create(:path => 'spec/test_data/css/with-asset.css')
    asset.assets.should == [Asset.create(:path => 'spec/test_data/css/imported.css')] 
  end

  it "removes the translated assets that are nil" do
    def @composite.children_paths 
      ['a', 'b', 'c']
    end
    def @composite.translate(url, parent_url)
      return nil if url == 'b'
      url
    end
    
    expected = ['a', 'c'].map{|p| TestAsset.new(:virtual_path => p, :path => p)}
    @composite.assets.should == expected
  end
end