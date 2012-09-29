module Trackman
  module Assets
    autoload :Asset, 'trackman/assets/asset'
    autoload :HtmlAsset, 'trackman/assets/html_asset'
    autoload :RemoteAsset, 'trackman/assets/remote_asset'
    autoload :CssAsset, 'trackman/assets/css_asset'

    autoload :CompositeAsset, 'trackman/assets/composite_asset'
    autoload :AssetFactory, 'trackman/assets/asset_factory'
    autoload :BundledAsset, 'trackman/assets/bundled_asset'
    autoload :RemoteAssetFactory, 'trackman/assets/remote_asset_factory'
    autoload :Persistence, 'trackman/assets/persistence'
  end
end