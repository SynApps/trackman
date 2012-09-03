module Trackman
  module Assets
    module Components
      module RemoteAssetFactory
        include AssetFactory

        def retrieve_parent(path)
          RemoteAsset
        end
      end
    end
  end
end