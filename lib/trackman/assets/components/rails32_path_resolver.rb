require 'sprockets'

module Trackman
  module Assets
    module Components  
      module Rails32PathResolver
        include PathResolver
        
        def translate url, parent_url 
          root = working_dir.realpath
          path = url

          path.slice! /^(\/assets|assets\/)/
          path = Pathname.new path

          path = prepare_for_sprocket(path, parent_url, root) if path.relative?
          begin
            path = sprockets.resolve path
          rescue Exception
            return nil
          end
          path.relative_path_from(root).to_s
        end

        def sprockets 
          @@sprockets ||= init_env
        end

        def prepare_for_sprocket path, parent_url, root
          folder = (root + Pathname.new(parent_url)).parent.realpath
          path = (folder + path).to_s
          path.slice! sprockets.paths.select{|p| path.include? p }.first
          path
        end
        
        def init_env
          env = ::Sprockets::Environment.new
          
          paths = ['app', 'lib', 'vendor'].inject([]) do |array, f|
            array + ["images", "stylesheets", "javascripts"].map{|p| "#{working_dir}/#{f}/assets/#{p}" }
          end
          
          paths << "#{working_dir}/public"
          paths.each{|p| env.append_path p }
          env
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