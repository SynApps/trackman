# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper.rb"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
require 'trackman'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end


module Trackman
  module Assets
    module Components  
      module Rails32PathResolver
        def sprockets
          @@sprockets ||= init_env
        end
        
        def init_env
          env = ::Sprockets::Environment.new
          paths = ['app', 'lib', 'vendor'].inject([]) do |array, f|
            array + ["images", "stylesheets", "javascripts"].map{|p| "#{working_dir}/#{f}/assets/#{p}" }
          end
          paths << "#{working_dir}/public"
          paths.each{|p| env.append_path p }

          env
        end
      end
    end
  end
end


Asset = Trackman::Assets::Asset unless defined?(Asset)
CssAsset = Trackman::Assets::CssAsset unless defined?(CssAsset)
HtmlAsset = Trackman::Assets::HtmlAsset unless defined?(HtmlAsset)
RemoteAsset = Trackman::Assets::RemoteAsset unless defined?(RemoteAsset)

PathResolver = Trackman::Assets::Components::PathResolver unless defined?(PathResolver)
Rails32PathResolver = Trackman::Assets::Components::Rails32PathResolver unless defined?(Rails32PathResolver)
RailsPathResolver = Trackman::Assets::Components::RailsPathResolver unless defined?(RailsPathResolver)
ConfigurationHandler = Trackman::ConfigurationHandler unless defined?(ConfigurationHandler)