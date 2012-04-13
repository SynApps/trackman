module Trackman
  module Assets
    class CssAsset < Asset
      include Components::CompositeAsset

      def assets
        @@url ||= /url\(['"]?(?<url>[^'")]+)['"]?\)/
        @@import ||= /url\(['"]?[^'"]+['"]?\)/

        imports = data.scan(@@import)

        to_assets(imports.collect{|x| @@url.match(x)[:url] })
      end
    end
  end
end