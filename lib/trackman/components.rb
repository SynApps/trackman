module Trackman
  module Components
    @@modules = [:Conventions, :Diffable, :Hashable, 
      :Shippable, :CompositeAsset, :AssetFactory, :PathResolver, 
      :Rails32PathResolver, :RailsPathResolver, :BundledAsset, :RemoteAssetFactory]
   
    Trackman.autoloads 'trackman/components', @@modules do |s,p|
        autoload s, p 
    end
  end
end