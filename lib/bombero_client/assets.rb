module BomberoClient
  module Assets
    autoload :Asset, 'bombero_client/assets/asset'
    autoload :HtmlAsset, 'bombero_client/assets/html_asset'
    autoload :RemoteAsset, 'bombero_client/assets/remote_asset'
    autoload :AssetNotFoundError, 'bombero_client/assets/asset_not_found_error'
  end
end