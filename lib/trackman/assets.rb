class String
  def trackman_underscore
    word = dup
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end
end

class Symbol
  def trackman_underscore
    to_s.trackman_underscore
  end
end

module Trackman
  module Assets
    
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

    @@classes = [:Asset, :HtmlAsset, :RemoteAsset, :CssAsset]
    @@modules = [:Components, :Errors, :Frameworks]

    autoloads 'trackman/assets', @@classes.concat(@@modules)
  end
end


