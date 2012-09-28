module Trackman
  module Errors
    @@classes = [:AssetNotFoundError, :ConfigNotFoundError, :ConfigSetupError]
    
    Trackman.autoloads 'trackman/errors', @@classes do |s,p|
        autoload s, p 
    end
  end
end