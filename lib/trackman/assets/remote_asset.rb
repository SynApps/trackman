require 'rest-client'
require 'uri'
 
module Trackman
  module Assets
    class RemoteAsset < Asset
      extend RemoteAssetFactory
      include Persistence::Remote

      attr_reader :id

      def initialize attributes = {}
        ensure_config
        super

        @id = attributes[:id]
        @file_hash = attributes[:file_hash]
      end
      
      def validate_path?
        false
      end

      def ==(other)
        result = super
        if result
          if other.is_a? RemoteAsset
            result = other.id == id && other.file_hash == file_hash 
          end
          return result
        end
        false 
      end

      private
        def build_params
          { :asset => { :virtual_path => virtual_path.to_s, :path => path.to_s, :file => AssetIO.new(path.to_s, data) }, :multipart => true }
        end 
        def ensure_config
          raise Errors::ConfigNotFoundError, "The config TRACKMAN_URL is missing." if self.class.server_url.nil?      
        end
        class AssetIO < StringIO
          attr_accessor :filepath

          def initialize(*args)
            super(*args[1..-1])
            @filepath = args[0]
          end

          def original_filename
            File.basename(filepath)
          end
           def content_type
            MIME::Types.type_for(path).to_s
          end
          def path
            @filepath
          end
        end
    end 
  end
end