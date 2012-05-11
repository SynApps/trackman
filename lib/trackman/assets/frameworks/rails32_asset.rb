module Trackman
  module Assets
    module Frameworks
      module Rails32Asset 
        
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

            components.insert(1, 'assets') if components.index('assets').nil?
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
            path[0..3].include? 'app'
          end
      end
    end 
  end
end