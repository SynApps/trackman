module BomberoClient
  module Assets
    class Asset
      extend Conventions
      extend Diffable
      include Hashable
      include Comparable
      extend Shippable

      def initialize attributes = {}
        super

        path = attributes[:path]
        path = Pathname.new path unless path.nil? || path.is_a?(Pathname)

        if validate_path?
          unless path && path.exist? && path.file?
            raise AssetNotFoundError, "The path '#{path}' is invalid or is not a file"
          end
        end

        @path = path
        @assets = []  
      end
      
      attr_reader :path, :assets

      def self.create attributes = {}
        path = attributes[:path]
        asset = HtmlAsset.new attributes if File.extname(path) == '.html'
        asset ||= Asset.new(attributes)
      end  
      
      def ==(other)
        return false if other.nil?
        other_path = other.path.is_a?(Pathname) ? other.path : Pathname.new(other.path) 
        other_path.to_s == path.to_s || path.realpath == other_path.realpath
      end
      
      def self.all
        if maintenance_path.exist?
          assets = [maintenance_page] + maintenance_page.assets 
          assets = assets + [error_page] + error_page.assets if error_path.exist?
           
          return assets.uniq{|a| a.path.realpath }.sort
        else
          return []
        end  
      end
      
      def to_remote
        RemoteAsset.new(:path => path)
      end

      
      def <=>(another)
        result = 0
        result += 1 if self.path.extname == '.html'
        result -= 1 if another.path.extname == '.html'
        result
      end
      
      protected
        def validate_path?
          true
        end
    end 
  end
end