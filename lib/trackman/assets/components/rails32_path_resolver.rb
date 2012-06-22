module Trackman
  module Assets
    module Components  
      module Rails32PathResolver
        include PathResolver
        
        def translate url, parent_url 
          root = working_dir.realpath
          
          path = url
          path.slice! /^\/assets/
          path = Pathname.new path
          
          if path.relative?          
            folder = (root + Pathname.new(parent_url)).parent.realpath
            path = (folder + path).to_s
            path.slice! sprockets.paths.select{|p| path.include? p }.first 
          end
          
          path = sprockets.resolve path
          path.relative_path_from(root).to_s
        end

        @@sprockets = nil
        def sprockets
          unless @@sprockets
            @@sprockets = ::Sprockets::Environment.new
            
            paths = []
            ['app', 'lib', 'vendor'].each do |f|
              paths = paths + ["images", "stylesheets", "javascripts"].map{|p| "#{working_dir}/#{f}/assets/#{p}" }
            end
            paths << "#{working_dir}/public"
              
            paths.each{|p| @@sprockets.append_path p }
          end
          @@sprockets
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
      end
    end
  end
end