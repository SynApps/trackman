module Trackman
  module Path  
    module Rails32Resolver
      include RailsResolver
      
      alias old_rails_translate translate

      def translate url, parent_url 
        root = working_dir.realpath
        
        path = url.dup
        path.slice! /^(\/assets|assets\/)/
        path = Pathname.new path

        path = prepare_for_sprocket(path, parent_url, root) if path.relative?
        begin
          path = sprockets.resolve path
        rescue Sprockets::FileNotFound => e
          Trackman::Utility::Debugger.trace "Sprocket did not find path: #{path}\n#{e.message}"
          return old_rails_translate(url, parent_url)
        end
        path.relative_path_from(root).to_s
      end
      

      def prepare_for_sprocket path, parent_url, root
        folder = (root + Pathname.new(parent_url)).parent.realpath
        path = (folder + path).to_s
        
        same_path = sprockets.paths.select{|p| path.include? p }.first
        path.slice!(same_path) unless same_path.nil?
        
        path
      end
      
      def sprockets
        ::Rails.application.assets
      end
    end
  end
end
