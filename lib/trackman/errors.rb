module Trackman
  module Errors
    @@classes = [:AssetNotFoundError, :ConfigNotFoundError]
    ::Trackman::Assets.autoloads 'trackman/errors', @@classes do |s,p|
        autoload s, p 
    end
  end
end