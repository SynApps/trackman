module BomberoClient
  module Assets
    class Asset
      def initialize path
        raise AssetNotFoundError, "The path '#{path}' is invalid" unless File.exists? path
        @path = path
        super  
      end
      def assets
        []
      end
      def path 
        @path
      end 
      
      def ==(other)
        if other
          return path == other.path
        else
          return false
        end
      end
    end 
  end
end