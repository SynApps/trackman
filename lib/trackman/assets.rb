module Trackman
  module Assets
    @@classes = [:Asset, :HtmlAsset, :RemoteAsset, :CssAsset]

    Trackman.autoloads 'trackman/assets', @@classes do |s, p|
      autoload s, p
    end
  end
end