module Trackman
  module Assets
    module Errors
      @@classes = [:AssetNotFoundError, :ConfigNotFoundError]
      ::Trackman::Assets.autoloads 'trackman/assets/errors', @@classes do |s,p|
          autoload s, p 
      end
    end
  end
end