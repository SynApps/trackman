module BomberoClient
  module Assets
    class RemoteAsset < Asset
      def initialize attributes = {}
        super

        @hash = attributes[:hash]
      end

        attr_accessor :hash
    end
  end
end