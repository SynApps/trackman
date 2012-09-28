if defined?(Rails)
  if ::Rails::VERSION::STRING =~ /^2\.[1-9]/
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
    require './config/environment'
    Rails.configuration.middleware.use Trackman::RackMiddleware 
  elsif ::Rails::VERSION::STRING =~ /^[3-9]\.[1-9]/
    require 'generators/controller/controller_generator'
    module Trackman
      class Railtie < Rails::Railtie
        rake_tasks do
          path = '../rails_generators/trackman_tasks/templates/*.rake'
          Dir[File.join(File.dirname(__FILE__), path)].each { |f| load f }
        end

        initializer "trackman.hook" do |app|
          app.config.after_initialize do
            Trackman::Assets::Asset.autosync
          end
        end
      end
    end
  end
end