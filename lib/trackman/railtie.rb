module Trackman
  class Railtie < Rails::Railtie
    initializer "trackman.hook" do |app|
      #app.config.middleware.use "Trackman::RackMiddleware"
      app.config.after_initialize do
        Trackman::Assets::Asset.autosync
      end
    end
  end
end

