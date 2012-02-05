module BomberoClient
  module Assets
    class HtmlAsset < Asset
      def assets
         doc = Nokogiri::HTML(File.open(@path))
         
      end  
    end 
  end
end