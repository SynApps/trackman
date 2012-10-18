require 'nokogiri'
module Trackman
  module Assets
    class HtmlAsset < Asset
      include CompositeAsset, Trackman::Urls::HtmlParser

      def children_paths
        @children ||= parse(data)
      end
    end 
  end
end