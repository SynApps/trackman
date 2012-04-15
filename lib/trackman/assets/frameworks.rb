module Trackman
  module Assets
    module Frameworks
      @@modules = [:Rails32Asset]
     
      ::Trackman::Assets.autoloads 'trackman/assets/frameworks', @@modules do |s,p|
          autoload s, p 
      end
    end
  end
end