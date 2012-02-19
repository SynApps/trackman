require 'rest-client'
module BomberoClient
  module Server
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def select_new assets
        assets = [assets] unless assets.is_a? Array
        response = RestClient.get 'http://127.0.0.1:3000/heroku/resources/123/assets', {:params => {:id => 50, 'foo' => 'bar' }}

      end
      
      def diff 
        local_assets = all
        server_assets = remote_assets
        
        { 
          :create => local_assets.select{|a| server_assets.all? { |s| a.path != s.path } }.to_a, 
          :update => local_assets.select{|a| server_assets.any?{ |s| a.path == s.path && a.hash != s.hash } }.to_a,  
          :delete => server_assets.select{|a| local_assets.all? { |s| s.path != a.path } }.to_a
        }        
      end

      def remote_assets
        remote_server = ENV['remote_server'] || "http://127.0.0.1:3000/heroku/resources"   
        response = RestClient.get "#{remote_server}/assets", {:params => {:id => 50, 'foo' => 'bar' }}
      end

    end

  end
end