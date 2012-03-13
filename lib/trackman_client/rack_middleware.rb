require 'trackman_client'
module TrackmanClient
  class RackMiddleware
    def initialize(app)
      @app = app
      
      TrackmanClient::Assets::Asset.autosync
    end
    
    def call(env)
      @app.call(env)
    end
  end
end