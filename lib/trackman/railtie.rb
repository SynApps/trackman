module Trackman
  class Railtie < Rails::Railtie
    initializer "trackman.insert_middleware" do |app|
      app.config.middleware.use "Trackman::RackMiddleware"
    end
  end
end