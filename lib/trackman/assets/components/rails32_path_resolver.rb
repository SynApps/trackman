require 'sprockets'

module Trackman
  module Assets
    module Components  
      module Rails32PathResolver
        include PathResolver
        
        def translate url, parent_url 
          root = working_dir.realpath
          
          path = url.dup
          path.slice! /^(\/assets|assets\/)/
          path = Pathname.new path

          path = prepare_for_sprocket(path, parent_url, root) if path.relative?
          begin
            path = sprockets.resolve path
          rescue Sprockets::FileNotFound => e
            Debugger.trace "Could not find path: #{path}\n#{e.message}"
            return nil
          end
          path.relative_path_from(root).to_s
        end
        
        def prepare_for_sprocket path, parent_url, root
          folder = (root + Pathname.new(parent_url)).parent.realpath
          path = (folder + path).to_s
          path.slice! sprockets.paths.select{|p| path.include? p }.first
          path
        end
        
        def sprockets
          ::Rails.application.assets
        end
      end
    end
  end
end
