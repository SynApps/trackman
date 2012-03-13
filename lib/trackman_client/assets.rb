module TrackmanClient
  module Assets
    @@asset_path = 'trackman_client/assets'
    
    @@classes = [:Asset, :HtmlAsset, :AssetNotFoundError, :ConfigNotFoundError, :RemoteAsset]
    @@modules = [:Conventions, :Hashable, :Diffable, :Shippable]

    
    def self.underscore(camel_cased_word)
      word = camel_cased_word.to_s.dup
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end

    @@classes.concat(@@modules).each do |s|
      autoload s, "#{@@asset_path}/#{underscore(s)}" 
    end
  end
end