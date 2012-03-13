require 'trackman_client'
module Trackman
  class RackMiddleware
    def initialize(app)
      @app = app
      
      Trackman::Assets::Asset.autosync
    end
    
    def call(env)
      @app.call(env)
    end
  end
end