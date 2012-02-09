require 'digest/md5' 
module BomberoClient
  module Assets
    class Asset
      def initialize path
        path = Pathname.new path unless path.is_a? Pathname
        raise AssetNotFoundError, "The path '#{path}' is invalid or is not a file" unless path.exist? && path.file?
        
        @path = path
        super  
      end
      
      def self.create(path)
        asset = HtmlAsset.new(path) if File.extname(path) == '.html'
        asset ||= Asset.new(path)
      end  
      
      def assets
        []
      end
      def path 
        @path
      end 
      def file
        @file ||= File.open(@path)
      end
      def data
        @data ||= read_file
      end

      def hash
        Digest::MD5.hexdigest(data)
      end
            
      def ==(other)
        other && path.realpath == other.path.realpath
      end

      def self.maintenance_path
        Pathname.new '/public/503.html'
      end
      def self.error_path
        Pathname.new '/public/503-error.html'
      end  
      def self.maintenance_page
        @@maintenance_page ||= Asset.create(maintenance_path)
      end
      def self.error_page
        @@error_page ||= Asset.create(error_path)
      end 
      
      def self.all
        if maintenance_path.exist?
          assets = [maintenance_page] + maintenance_page.assets 
          assets = assets + [error_page] + error_page.assets if error_path.exist?
           
          return assets.uniq{|a| a.path.realpath }
        else
          return []
        end  
      end
        
      protected
        def read_file
          begin
            return file.read
          rescue
            return nil
          ensure
            file.close 
          end    
        end
    end 
  end
end