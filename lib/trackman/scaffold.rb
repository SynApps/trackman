module Trackman
  module Scaffold
    
    #TODO do something better than this to share the scope
    def self.autoloads path, items
      items.each do |s|
        if block_given? 
          yield(s, "#{path}/#{s.trackman_underscore}" ) 
        else
          autoload s, "#{path}/#{s.trackman_underscore}" 
        end
      end
    end

    @@modules = [:ContentSaver]

    autoloads 'trackman/scaffold', @@modules
  end
end