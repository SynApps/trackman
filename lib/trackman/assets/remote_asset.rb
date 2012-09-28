require 'rest-client'
require 'json'
require 'uri'
require 'logger'
RestClient.log = Logger.new(STDOUT) if Trackman::Utility::Debugger.debug_mode?

module Trackman
  module Assets
    class RemoteAsset < Asset
      extend Components::RemoteAssetFactory

      @@server_url = ENV['TRACKMAN_URL']

      @@site = "#{@@server_url}/assets"
      attr_reader :id

      def initialize attributes = {}
        ensure_config
        super

        @id = attributes[:id]
        @file_hash = attributes[:file_hash]
      end
      
      def self.log_exception ex
        RestClient.post "#{@@server_url}/exceptions", :exception => { :message => ex.message, :backtrace => ex.backtrace }, :ssl_version => 'SSLv3'
      end

      def validate_path?
        false
      end

      def self.find id
        response = RestClient.get "#{@@site}/#{id}"
        
        body = Hash[JSON.parse(response).map{ |k, v| [k.to_sym, v] }]
  
        RemoteAsset.create(body)
      end

      def self.all
        get_attributes.map{ |r| RemoteAsset.create(r) }.sort
      end

      
      def insert
        response = RestClient.post @@site, build_params, :content_type => :json, :accept => :json, :ssl_version => 'SSLv3'
        path = response.headers[:location]
        @id = path[/\d+$/].to_i
      end

      def update
        RestClient.put "#{@@site}/#{id}", build_params, :content_type => :json, :accept => :json, :ssl_version => 'SSLv3'
      end  

      def delete
        response = RestClient.delete "#{@@site}/#{id}"
        true
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
          raise Errors::ConfigNotFoundError, "The config TRACKMAN_URL is missing." if @@server_url.nil?      
        end
        def self.get_attributes
          JSON.parse(RestClient.get @@site).map{|r|  Hash[r.map{ |k, v| [k.to_sym, v] }] }
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