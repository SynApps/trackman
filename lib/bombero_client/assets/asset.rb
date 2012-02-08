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

      protected
        def validate_and_save path
          
        end
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