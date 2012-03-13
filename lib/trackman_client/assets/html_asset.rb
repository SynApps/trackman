require 'nokogiri'
module TrackmanClient
  module Assets
    class HtmlAsset < Asset
      
      def initialize attributes = {}
        super
        @assets = nil
      end
        
      def document
        @doc ||= Nokogiri::HTML(data)     
      end  
      
      def assets
        @assets ||= javascripts + stylesheets + images
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

      protected
        def to_assets nodes, attr
          nodes.collect{ |n| n[attr] }
            .select{|p| internal? p }
            .collect { |p| Asset.create(:path => to_path(p)) }
            .to_a
        end  
        def to_path(img)
          return Pathname.new img if File.exist? img
          Pathname.new "#{path.parent}/#{img}"
        end 
        def internal? path
          path !~ /(\/|http)/
        end 
    end 
  end
end