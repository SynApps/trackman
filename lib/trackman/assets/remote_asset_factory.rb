module Trackman
  module Assets
    module RemoteAssetFactory
      include Assets::AssetFactory

      def retrieve_parent(path)
        RemoteAsset
      end
    end
  end
end