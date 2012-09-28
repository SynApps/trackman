module Trackman
  module Utility
    @@modules = [:Configuration, :Debugger]
   
    ::Trackman.autoloads 'trackman/utility', @@modules do |s,p|
        autoload s, p 
    end
  end
end