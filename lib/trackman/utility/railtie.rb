require File.expand_path('../middleware', __FILE__)

if defined?(Rails)
  if ::Rails::VERSION::STRING =~ /^2\.[1-9]/
    require './config/environment'
    Rails.configuration.middleware.use Trackman::Middleware 
  elsif ::Rails::VERSION::STRING =~ /^3\.[1-9]/ || ::Rails::VERSION::STRING =~ /^[4-9]\.[0-9]/
    require 'generators/controller/controller_generator'
    module Trackman
      class Railtie < Rails::Railtie
        rake_tasks do
          load File.expand_path('../../../../rails_generators/trackman_tasks/templates/trackman.rake', __FILE__)
        end
      end
    end
  end
end
