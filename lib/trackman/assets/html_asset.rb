require 'nokogiri'
module Trackman
  module Assets
    class HtmlAsset < Asset
      include Components::CompositeAsset
      
      def initialize attributes = {}
        super
        @assets = nil
      end
        
      def document
        @doc ||= Nokogiri::HTML(data)     
      end  
        
      def images        
        @images ||= to_assets(document.css('img'), 'src')
      end
      def javascripts
        @js ||= to_assets(document.xpath('//script'), 'src')
      end
      def stylesheets
        @css ||= to_assets(document.xpath('//link[@type="text/css"]'), 'href')
      end

      def assets
        @assets ||= javascripts + stylesheets + images
      end
      
      protected
        def to_assets nodes, attr
          super nodes.collect{ |n| n[attr] }
        end
    end 
  end
end