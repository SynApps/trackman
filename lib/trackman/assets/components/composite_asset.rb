module Trackman
  module Assets
    module Components
      module CompositeAsset

        def self.included(mod)
          mod.send(:include, PathResolver)
        end
        def self.extended(mod)
          mod.send(:extend, PathResolver)
        end

        def assets
          internals = children_paths.select{|p| p.internal_path? }.map{|p| {old: p, new_path: translate(p, path)} }
          internals.select{|p| !p[:new_path].nil? }.map{|p| asset_from(p[:old], p[:new_path])}.inject([]) do |sum, a|
            sum << a
            sum.concat(a.assets.select{|child| !sum.include?(child) })
            sum
          end
        end
        
        def asset_from(virtual, physical)
          Asset.create(:virtual_path => virtual.dup, :path => physical)  
        end
        
        def inner_css_paths
          @@url ||= /url\(['"]?([^'")]+)['"]?\)/
          @@import ||= /url\(['"]?[^'"]+['"]?\)/

          data.scan(@@import).collect{|x| @@url.match(x)[1] }
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