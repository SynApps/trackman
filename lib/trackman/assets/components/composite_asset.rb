module Trackman
  module Assets
    module Components
      module CompositeAsset

        def self.included(mod)
          mod.send(:include, PathMan)
        end
        def self.extended(mod)
          mod.send(:extend, PathMan)
        end

        def assets
          children_paths
            .select{|p| p.internal_path? }
            .inject([]) do |array, p|
              asset = Asset.create(:path => translate(p, path))  
              array << asset 
              array.concat(asset.assets.select{|a| !array.include?(a) })
              array   
            end
        end
        
        def inner_css_paths
          @@url ||= /url\(['"]?(?<url>[^'")]+)['"]?\)/
          @@import ||= /url\(['"]?[^'"]+['"]?\)/

          data.scan(@@import).collect{|x| @@url.match(x)[:url] }
        end
      end
    end
  end
end

class String
  def internal_path? 
    self !~ /^http/
  end 
end