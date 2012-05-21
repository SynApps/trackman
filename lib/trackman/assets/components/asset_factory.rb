module Trackman
  module Assets
    module Components
      module AssetFactory
        def create attributes = {}
          path = attributes[:path]
          
          if File.extname(path) == '.html'
            parent = HtmlAsset
          elsif File.extname(path) == '.css'
            parent = CssAsset 
          else
            parent = Asset
          end 

          instance = parent.new attributes
          instance.extend Rails32PathResolver if asset_pipeline_enabled?
          instance
        end

        def rails_defined?
          const_defined? :Rails
        end

        def asset_pipeline_enabled?
           rails_defined? && 
           Rails.respond_to?(:application) &&
           Rails.application.respond_to?(:config) &&
           Rails.application.config.respond_to?(:assets) && 
           Rails.application.config.assets.enabled
        end  
      end
    end
  end
end