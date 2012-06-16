require 'rest-client'
require 'json'
require 'uri'

module Trackman
  module Assets
    class RemoteAsset < Asset
      @@server_url = ENV['TRACKMAN_URL']
      @@site = "#{@@server_url}/assets"

      attr_reader :id

      def initialize attributes = {}
        ensure_config
        super

        @id = attributes[:id]
        @file_hash = attributes[:file_hash]
      end
      
      def file_hash
        @file_hash || super
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
        JSON.parse(RestClient.get @@site).map{|r|  Hash[r.map{ |k, v| [k.to_sym, v] }] }.map { |r| RemoteAsset.new(r) }.sort
      end

      def create!
        puts "server = #{@@server_url}"
        puts "site = #{@@site}"
        response = RestClient.post @@site, :asset => {:path => path.to_s, :file => File.open(path)}, :content_type => :json, :accept => :json
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
            result = other.id == id && other.file_hash == file_hash 
          end
          return result
        end
        false 
      end

      private 
        def ensure_config
          raise Errors::ConfigNotFoundError, "The config TRACKMAN_URL is missing." if @@server_url.nil?      
        end
    end 
  end
end