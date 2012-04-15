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
          to_include = []
          
          if const_defined?(:Rails) 
            if ::Rails::VERSION::STRING =~ /^[3-9]\.[1-9]/
              to_include << Rails32Asset
            end
          end

          klass = Class.new(parent) do
            to_include.each do |f|
              include f
            end
          end

          klass.new attributes
        end
      end
    end
  end
end