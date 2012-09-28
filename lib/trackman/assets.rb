module Trackman
  module Assets
    @@classes = [:Asset, :HtmlAsset, :RemoteAsset, :CssAsset]
    @@modules = [:CompositeAsset, :AssetFactory,  :BundledAsset, :RemoteAssetFactory, :Persistence]
    
    Trackman.autoloads 'trackman/assets', (@@classes + @@modules) do |s, p|
      autoload s, p
    end
  end
end