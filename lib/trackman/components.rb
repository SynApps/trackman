module Trackman
  module Components
    @@modules = [:Conventions, :Diffable, :Hashable, :Shippable]
   
    Trackman.autoloads 'trackman/components', @@modules do |s,p|
        autoload s, p 
    end
  end
end