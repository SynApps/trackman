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

  def self.debug_mode?
  	!ENV['TRACKMAN_DEBUG_MODE'].nil? && ENV['TRACKMAN_DEBUG_MODE'] == 'true'
  end

  def self.trace data
  	puts data if debug_mode?
  end
end