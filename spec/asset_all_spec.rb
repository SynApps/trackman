require 'spec_helper'

describe TrackmanClient::Assets::Asset do
  describe "#all" do
    Asset = TrackmanClient::Assets::Asset 
    it "returns every asset for a given maintenance path" do
      class Asset
        def self.maintenance_page
          Asset.create(:path => 'spec/test_data/all/all.html')
        end 
        def self.maintenance_path
          Pathname.new('spec/test_data/all/all.html')
        end
      end 

      expected = [Asset.create(:path => 'spec/test_data/all/2.gif'), Asset.create(:path => 'spec/test_data/all/1.css'), Asset.maintenance_page]
      Asset.all.should eq(expected)
    end


    it "includes assets from error page if it is also specified" do
      class Asset
        def self.maintenance_page
          Asset.create(:path => 'spec/test_data/all/all.html')
        end
        def self.error_page
          Asset.create(:path => 'spec/test_data/all/all2.html')
        end 

        def self.maintenance_path
          Pathname.new('spec/test_data/all/all.html')
        end
        def self.error_path
          Pathname.new('spec/test_data/all/all2.html')
        end 
      end 

      expected = [
        Asset.create(:path => 'spec/test_data/all/3.js'),
        Asset.create(:path => 'spec/test_data/all/1.css'),
        Asset.create(:path => 'spec/test_data/all/2.gif'), 
        Asset.error_page,
        Asset.maintenance_page
      ]

      Asset.all.should eq(expected)
    end

    it "does not include the same asset twice" do
      class Asset
        def self.maintenance_page
          Asset.create(:path => 'spec/test_data/all/all.html')
        end
        def self.error_page
          Asset.create(:path => 'spec/test_data/all/all3.html')
        end
        def self.maintenance_path
          Pathname.new('spec/test_data/all/all.html')
        end
        def self.error_path
          Pathname.new('spec/test_data/all/all3.html')
        end  
      end 

      expected = [
        Asset.create(:path => 'spec/test_data/all/2.gif'), 
        Asset.create(:path => 'spec/test_data/all/1.css'), 
        Asset.maintenance_page, 
        Asset.error_page
      ]
      
      actual = Asset.all
      
      actual.should eq(expected)
    end

    it "does not include external assets" do
      class Asset
        def self.maintenance_page
          Asset.create(:path => 'spec/test_data/external_paths/1.html')
        end
        def self.error_page
          Asset.create(:path => '/invalid/path')
        end
        def self.maintenance_path
          Pathname.new('spec/test_data/external_paths/1.html')
        end 
        def self.error_path
          Pathname.new('/invalid/path')
        end  
      end 

      expected = [Asset.create(:path => 'spec/test_data/external_paths/1.css'), Asset.maintenance_page]
      
      Asset.all.should eq(expected)
    end

    it "return html assets always at the end" do
      class Asset
        def self.maintenance_page
          Asset.create(:path => 'spec/test_data/external_paths/1.html')
        end
        def self.error_page
          Asset.create(:path => 'spec/test_data/external_paths/1.html')
        end
        def self.maintenance_path
          Pathname.new('spec/test_data/external_paths/1.html')
        end 
        def self.error_path
          Pathname.new('spec/test_data/external_paths/1.html')
        end  
      end
     
      expected = [Asset.create(:path => 'spec/test_data/external_paths/1.css'), Asset.maintenance_page] 
      Asset.all.should eq(expected)
    end
  end
end