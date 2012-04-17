require 'nokogiri'
module Trackman
  module Assets
    class HtmlAsset < Asset
      include Components::CompositeAsset

      def document
        @doc ||= Nokogiri::HTML(data)     
      end  
      
      def img_paths        
        @images_paths ||= refine_path(document.css('img'), 'src')
      end
      def js_paths
        @js_paths ||= refine_path(document.xpath('//script'), 'src')
      end
      def css_paths
        @css_paths ||= refine_path(document.xpath('//link[@type="text/css"]'), 'href')
      end

      def children_paths
         @children_paths ||= img_paths + js_paths + css_paths + inner_css_paths
      end

      protected 
        def refine_path(paths, node)
          paths.collect{|n| n[node].to_s }
            .select{|p| p.internal_path? }
            .collect{|n| to_path(n).to_s }
        end
    end 
  end
end