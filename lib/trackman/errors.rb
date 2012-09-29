module Trackman
  module Errors
    autoload :AssetNotFoundError, 'trackman/errors/asset_not_found_error'
    autoload :ConfigNotFoundError, 'trackman/errors/config_not_found_error'
    autoload :ConfigSetupError, 'trackman/errors/config_setup_error'
  end
end