module Trackman
  module Assets
    module Components
      @@classes = [:Conventions, :Diffable, :Hashable, :Shippable]
     
      ::Trackman::Assets.autoloads 'trackman/assets/components', @@classes do |s,p|
          autoload s, p 
      end
    end
  end
end