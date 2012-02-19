#require 'activeresource'
module BomberoClient
  module Assets
    class RemoteAsset # < ActiveResource::Base
      extend Conventions
      include Hashable
      include Diffable

      #self.site = "http://127.0.0.1:3000/"

      def initialize attributes = {}
        path = attributes[:path]
        path = Pathname.new path unless path.is_a? Pathname 
        
        @path = path
        @hash = attributes[:hash]
      end

      attr_reader :hash, :path

      def ==(other)
        other && path.realpath == other.path.realpath
      end
    end 
  end
end