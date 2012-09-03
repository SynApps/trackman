module Trackman
  module Assets
    module Components
      module CompositeAsset
        @@url = /url\(['"]?([^'")]+)['"]?\)/
        @@import = /url\(['"]?[^'"]+['"]?\)/
        
        def self.included(mod)
          mod.send(:include, PathResolver)
        end
        def self.extended(mod)
          mod.send(:extend, PathResolver)
        end

        def assets
          internals = children_paths.select{|p| p.internal_path? }.map{|p| {old: p, new_path: translate(p, path)} }
          internals = internals.select{|p| !p[:new_path].nil? }.map{|p| asset_from(p[:old], p[:new_path])}
          internals.inject([]) do |sum, a|
            (sum << a) + a.assets.select{|child| !sum.include?(child) }
          end
        end
        
        def asset_from(virtual, physical)
          Asset.create(:virtual_path => virtual, :path => physical)  
        end
        
        def inner_css_paths
          data.scan(@@import).collect{|x| @@url.match(x)[1]}.select{|x| !x.embedded? }
        end
      end
    end
  end
end

class String
  def internal_path? 
    self !~ /^http/
  end
  def embedded?
    self.include? 'data:'
  end 
end