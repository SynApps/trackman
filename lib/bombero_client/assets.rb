module BomberoClient
  module Assets
    autoload :Asset, 'bombero_client/assets/asset'
    autoload :HtmlAsset, 'bombero_client/assets/html_asset'
    autoload :AssetNotFoundError, 'bombero_client/assets/asset_not_found_error'
    autoload :ConfigNotFoundError, 'bombero_client/assets/config_not_found_error'
    autoload :RemoteAsset, 'bombero_client/assets/remote_asset'

    #modules
    autoload :Conventions, 'bombero_client/assets/conventions'
    autoload :Hashable, 'bombero_client/assets/hashable'
    autoload :Diffable, 'bombero_client/assets/diffable'
    autoload :Shippable, 'bombero_client/assets/shippable'
  end
end