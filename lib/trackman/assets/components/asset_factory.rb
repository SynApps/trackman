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
          klass = build_class_from(parent)

          klass.new attributes
        end

        def uses_rails32?
          const_defined?(:Rails)  &&  ::Rails::VERSION::STRING =~ /^[3-9]\.[1-9]/
        end

        protected 
          def build_class_from(parent)
            to_include = []
            to_include << Rails32PathResolver if uses_rails32?
          
            klass = Class.new(parent) do
              to_include.each do |f|
                include f
              end
            end
            klass
          end
      end
    end
  end
end