require 'rest-client'
require 'json'

module BomberoClient
  module Assets
    class RemoteAsset < Asset
      @@user = ENV['BOMBERO_USERNAME']
      @@pass = ENV['BOMBERO_PASSWORD']
      @@app_id = ENV['BOMBERO_APPLICATION_ID']
      
      @@site = "http://#{@@user}:#{@@pass}@127.0.0.1:3000/heroku/resources/#{@@app_id}/assets"

      attr_reader :id
      def initialize attributes = {}
        super
        @id = attributes[:id]
        @hash = attributes[:file_fingerprint]
      end
      def hash
        @hash || super
      end

      def create!
        response = RestClient.post @@site, :asset => {:path => path, :file => File.open(path)}, :content_type => :json, :accept => :json
        path = response.headers[:location]
        @id = path[/\d+$/].to_i
      end
 
      def self.find id
        response = RestClient.get "#{@@site}/#{id}"
        body = Hash[JSON.parse(response).map{ |k, v| [k.to_sym, v] }]
        RemoteAsset.new(body)
      end

      def ==(other)
        result = super
        if result
          if other.is_a? RemoteAsset
            result = other.id == id && other.hash == hash 
          end
          return result
        end
        false 
      end

      private
        def eql_remote?
        end
    end 
  end
end