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
          instance.extend Rails32PathResolver if uses_rails32?
          instance
        end

        def uses_rails32?
          const_defined?(:Rails)  &&  ::Rails::VERSION::STRING =~ /^[3-9]\.[1-9]/
        end
      end
    end
  end
end