module Trackman
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
          instance.extend Rails32Resolver, BundledAsset
          return instance
        elsif rails_defined? #fallback to rails without asset pipeline
          instance.extend RailsResolver
        end
        instance.extend Hashable

        instance
      end
      
      def rails_defined?
        Object.const_defined?(:Rails)
      end

      def asset_pipeline_enabled?
         rails_defined? && 
         Rails.respond_to?(:application) &&
         Rails.application.config.assets.enabled &&
         Rails.application.respond_to?(:assets) &&
         Rails.application.assets
      end  
    end
  end
end
