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
        
          if uses_rails32?
            instance.extend Rails32PathResolver
          elsif uses_rails? #fallback to rails without asset pipeline
            instance.extend RailsPathResolver
          end

          instance
        end

        def uses_rails?
          const_defined?(:Rails)
        end

        def uses_rails32?
          uses_rails?  &&  ::Rails::VERSION::STRING =~ /^[3-9]\.[1-9]/
        end
      end
    end
  end
end