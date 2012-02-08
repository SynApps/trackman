require 'nokogiri'
module BomberoClient
  module Assets
    class HtmlAsset < Asset
      
      def document
        @doc ||= Nokogiri::HTML(file)     
      end  
      
      def assets
        @assets ||= javascripts + stylessheets + images
      end  
      def images        
        @images ||= document.css('img').collect { |img| Asset.create(to_path img['src']) }.to_a
      end
      def javascripts
        @js ||= document.xpath('//script').collect { |js| Asset.create(to_path js['src']) }.to_a
      end
      def stylesheets
        @css ||= document.xpath('//link[@type="text/css"]').collect { |css| Asset.create(to_path css['href']) }.to_a
      end


      protected
        def to_path(img)
          return Pathname.new img if File.exist? img
          Pathname.new("#{path.parent}/#{img}")
        end  
    end 
  end
end