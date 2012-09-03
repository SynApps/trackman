module Trackman
  module Assets
    module Components
      module AssetFactory
        def create attributes = {}
          path = attributes[:path]
          instance = retrieve_parent(path).new attributes
          add_content_behavior instance
        end

        def retrieve_parent path
          if File.extname(path) == '.html'
            parent = HtmlAsset
          elsif File.extname(path) == '.css'
            parent = CssAsset 
          else
            parent = Asset
          end
          parent 
        end

        def add_content_behavior instance
          if asset_pipeline_enabled?
            instance.extend Rails32PathResolver, BundledAsset
          elsif rails_defined? #fallback to rails without asset pipeline
            instance.extend RailsPathResolver, Hashable
          else
            instance.extend Hashable
          end
          instance
        end
        
        def rails_defined?
          Object.const_defined?(:Rails)
        end

        def asset_pipeline_enabled?
           rails_defined? && 
           Rails.respond_to?(:application) &&
           Rails.application.respond_to?(:assets) &&
           Rails.application.config.assets.enabled
        end  
      end
    end
  end
end