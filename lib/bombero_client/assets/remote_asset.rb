require 'rest-client'
require 'json'

module BomberoClient
  module Assets
    class RemoteAsset < Asset
      @@user = ENV['BOMBERO_USERNAME']
      @@pass = ENV['BOMBERO_PASSWORD']
      @@app_id = ENV['BOMBERO_APPLICATION_ID']
      @@server = ENV['BOMBERO_SERVER']

      @@site = "http://#{@@user}:#{@@pass}@#{@@server}/heroku/resources/#{@@app_id}/assets"

      attr_reader :id
      def initialize attributes = {}
        super
        @id = attributes[:id]
        @hash = attributes[:file_hash]

        path = attributes[:path]
        path = Pathname.new path unless path.nil? || path.is_a?(Pathname)
        
        @path = path
        @assets = []  
      end
      
      def hash
        @hash || super
      end
      
      def validate_path?
        false
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
          .to_a
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
    end 
  end
end