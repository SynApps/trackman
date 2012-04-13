module Trackman
  module Assets
    module Components
      @@modules = [:Conventions, :Diffable, :Hashable, :Shippable, :CompositeAsset]
     
      ::Trackman::Assets.autoloads 'trackman/assets/components', @@modules do |s,p|
          autoload s, p 
      end
    end
  end
end