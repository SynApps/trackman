module Trackman
  module Assets
    
    def self.underscore(camel_cased_word)
      word = camel_cased_word.to_s.dup
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end

    #TODO do something better than this to share the scope
    def self.autoloads path, items
      items.each { |s|
        if block_given? 
          yield(s, "#{path}/#{underscore(s)}" ) 
        else
          autoload s, "#{path}/#{underscore(s)}" 
        end
      }
    end

    @@classes = [:Asset, :HtmlAsset, :RemoteAsset, :Rails32Asset, :CssAsset]
    @@modules = [:Components, :Errors]

    autoloads 'trackman/assets', @@classes.concat(@@modules)
  end
end