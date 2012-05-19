require 'spec_helper'

describe Trackman::Assets::Asset do
  class TestAsset < Asset
  end
  
  describe "#all" do
    it "returns every asset for a given maintenance path" do
      class TestAsset
        def self.maintenance_page
          Asset.create(:path => 'spec/test_data/all/all.html')
        end 
        def self.maintenance_path
          Pathname.new('spec/test_data/all/all.html')
        end
      end 

      expected = [
        TestAsset.create(:path => 'spec/test_data/all/1.css'), 
        TestAsset.create(:path => 'spec/test_data/all/2.gif'),  
        TestAsset.maintenance_page
      ]

      TestAsset.all
      
      TestAsset.all.should eq(expected)
    end


    it "includes assets from error page if it is also specified" do
      class TestAsset
        def self.maintenance_page
          TestAsset.create(:path => 'spec/test_data/all/all.html')
        end
        def self.error_page
          TestAsset.create(:path => 'spec/test_data/all/all2.html')
        end 

        def self.maintenance_path
          Pathname.new('spec/test_data/all/all.html')
        end
        def self.error_path
          Pathname.new('spec/test_data/all/all2.html')
        end 
      end 

      expected = [
        TestAsset.create(:path => 'spec/test_data/all/3.js'),
        TestAsset.create(:path => 'spec/test_data/all/2.gif'), 
        TestAsset.create(:path => 'spec/test_data/all/1.css'),
        TestAsset.maintenance_page,
        TestAsset.error_page
      ]

      TestAsset.all.should eq(expected)
    end

    it "does not include the same asset twice" do
      class TestAsset
        def self.maintenance_page
          TestAsset.create(:path => 'spec/test_data/all/all.html')
        end
        def self.error_page
          TestAsset.create(:path => 'spec/test_data/all/all3.html')
        end
        def self.maintenance_path
          Pathname.new('spec/test_data/all/all.html')
        end
        def self.error_path
          Pathname.new('spec/test_data/all/all3.html')
        end  
      end 

      expected = [
        TestAsset.create(:path => 'spec/test_data/all/1.css'), 
        TestAsset.create(:path => 'spec/test_data/all/2.gif'), 
        TestAsset.maintenance_page, 
        TestAsset.error_page
      ]
      
      actual = TestAsset.all
      
      actual.should eq(expected)
    end

    it "does not include external assets" do
      class TestAsset
        def self.maintenance_page
          TestAsset.create(:path => 'spec/test_data/external_paths/1.html')
        end
        def self.error_page
          TestAsset.create(:path => '/invalid/path')
        end
        def self.maintenance_path
          Pathname.new('spec/test_data/external_paths/1.html')
        end 
        def self.error_path
          Pathname.new('/invalid/path')
        end  
      end 

      expected = [TestAsset.create(:path => 'spec/test_data/external_paths/1.css'), TestAsset.maintenance_page]
      
      TestAsset.all.should eq(expected)
    end

    it "return html assets always at the end" do
      class TestAsset
        def self.maintenance_page
          TestAsset.create(:path => 'spec/test_data/external_paths/1.html')
        end
        def self.error_page
          TestAsset.create(:path => 'spec/test_data/external_paths/1.html')
        end
        def self.maintenance_path
          Pathname.new('spec/test_data/external_paths/1.html')
        end 
        def self.error_path
          Pathname.new('spec/test_data/external_paths/1.html')
        end  
      end
     
      expected = [TestAsset.create(:path => 'spec/test_data/external_paths/1.css'), TestAsset.maintenance_page] 
      TestAsset.all.should eq(expected)
    end
  end
end