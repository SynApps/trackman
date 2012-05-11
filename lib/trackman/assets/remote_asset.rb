require 'rest-client'
require 'json'

module Trackman
  module Assets
    class RemoteAsset < Asset
      @@user = ENV['TRACKMAN_USER']
      @@pass = ENV['TRACKMAN_PASSWORD']
      @@app_id = ENV['TRACKMAN_APP_ID']
      @@server = ENV['TRACKMAN_SERVER_URL']

      @@site = "http://#{@@user}:#{@@pass}@#{@@server}/heroku/resources/#{@@app_id}/assets"

      attr_reader :id
      
      def initialize attributes = {}
        ensure_config
        super

        @id = attributes[:id]
        @hash = attributes[:file_hash]
      end
      
      def hash
        @hash || super
      end
      
      def validate_path?
        false
      end

      def self.find id
        response = RestClient.get "#{@@site}/#{id}"
        body = Hash[JSON.parse(response).map{ |k, v| [k.to_sym, v] }]
        RemoteAsset.new(body)
      end

      def self.all
        JSON.parse(RestClient.get @@site)
          .map{|r|  Hash[r.map{ |k, v| [k.to_sym, v] }] }
          .map { |r| RemoteAsset.new(r) }
          .sort
      end

      def create!
        response = RestClient.post @@site, :asset => {:path => path, :file => File.open(path)}, :content_type => :json, :accept => :json
        path = response.headers[:location]
        @id = path[/\d+$/].to_i
      end

      def update!
        RestClient.put "#{@@site}/#{id}", :asset => {:path => path, :file => File.open(path)}, :content_type => :json, :accept => :json
      end  
      def delete
        response = RestClient.delete "#{@@site}/#{id}"
        true
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
        def ensure_config
          if @@user.nil? || @@pass.nil? || @@app_id.nil? || @@server.nil?
            config_missing = ['TRACKMAN_USER', 'TRACKMAN_PASSWORD', 'TRACKMAN_APP_ID', 'TRACKMAN_SERVER_URL'].first{|c| ENV[c].nil? }
            raise Errors::ConfigNotFoundError, "The config '#{config_missing}' is missing."
          end            
        end
    end 
  end
end