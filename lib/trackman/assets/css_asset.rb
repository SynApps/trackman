module Trackman
  module Assets
    class CssAsset < Asset
      include Components::CompositeAsset

      protected
        def children_paths
          @@url ||= /url\(['"]?(?<url>[^'")]+)['"]?\)/
          @@import ||= /url\(['"]?[^'"]+['"]?\)/

          data.scan(@@import).collect{|x| @@url.match(x)[:url] }
        end
    end
  end
end