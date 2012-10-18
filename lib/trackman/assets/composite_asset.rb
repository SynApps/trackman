module Trackman
  module Assets
    module CompositeAsset 
      def self.included(mod)
        mod.send(:include, Path::Resolver)
      end
      def self.extended(mod)
        mod.send(:extend, Path::Resolver)
      end

      def assets
        internals = children_paths.select{|p| p.internal_path? }.map{|p| {:old => p, :new_path => translate(p, path)} }
        internals = internals.select{|p| !p[:new_path].nil? }.map{|p| asset_from(p[:old], p[:new_path])}
        internals.inject([]) do |sum, a|
          (sum << a) + a.assets.select{|child| !sum.include?(child) }
        end
      end
      
      def asset_from(virtual, physical)
        Asset.create(:virtual_path => virtual, :path => physical)  
      end
    end
  end
end