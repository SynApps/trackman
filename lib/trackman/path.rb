module Trackman
  module Path
    @@modules = [:Resolver, :Rails32Resolver, :RailsResolver]
   
    Trackman.autoloads 'trackman/path', @@modules do |s,p|
        autoload s, p 
    end
  end
end