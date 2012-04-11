
module Trackman
  module Assets
    class Rails32Asset < Asset
      def initialize attributes = {}
        path = attributes[:path].to_s
        path.slice! /^\//
        attributes[:path] = change_path(path) unless is_local?(path)
        super attributes
      end

      protected
        def change_path path
          path = path.to_s
          components = path.split(File::SEPARATOR)
          components.insert(0, 'app')

          file = components.last
          index = components.index('assets') + 1
          subfolder = subfolder(file)
          
          components.insert(index, subfolder)
          components.join(File::SEPARATOR)
        end
        def subfolder(file)
          if file.include?('.js')
            subfolder = "javascripts"
          elsif file.include?('.css')
            subfolder = "stylesheets"
          else 
            subfolder = "images"
          end
          subfolder
        end
        def is_local? path
          path[0..3].to_s.include? 'app'
        end
    end 
  end
end