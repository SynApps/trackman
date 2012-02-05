
module BomberoClient
  autoload :RackMiddleware, 'bombero_client/rack_middleware'
  autoload :AssetProvider, 'bombero_client/asset_provider'
  autoload :Server, 'bombero_client/server'
  autoload :Assets, 'bombero_client/assets'
  
  def run
    @provider = AssetProvider.new
    @server = Server.new
    
    assets = @provider.assets
    changed_assets = @server.compare assets
    
    @server.push changed_assets
  end  
end  