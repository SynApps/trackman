module Trackman
  module Assets
    class CssAsset < Asset
      def assets
        @@url ||= /url\(['"]?(?<url>[^'")]+)['"]?\)/
        @@import ||= /url\(['"]?[^'"]+['"]?\)/

        imports = data.scan(@@import)

        to_assets(imports.collect{|x| @@url.match(x)[:url] })
      end

       protected
        def to_assets paths
          paths.select{|p| internal? p }
            .collect { |p| Asset.create(:path => to_path(p)) }
            .to_a
        end  
        def to_path(str_path)
          return Pathname.new str_path if File.exist? str_path
          Pathname.new "#{path.parent}/#{str_path}"
        end 
        def internal? path
          path !~ /(\/|http)/
        end 
    end
  end
end