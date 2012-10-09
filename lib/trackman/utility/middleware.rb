module Trackman
  class Middleware
    def initialize(app)
      @app = app
      Trackman::Assets::Asset.autosync
    end
    
    def call(env)
      @app.call(env)
    end
  end
end
