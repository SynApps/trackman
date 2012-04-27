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


Asset = Trackman::Assets::Asset unless defined?(Asset)
CssAsset = Trackman::Assets::CssAsset unless defined?(CssAsset)
HtmlAsset = Trackman::Assets::HtmlAsset unless defined?(HtmlAsset)
Rails32Asset = Trackman::Assets::Frameworks::Rails32Asset unless defined?(Rails32Asset)
RemoteAsset = Trackman::Assets::RemoteAsset unless defined?(RemoteAsset)