require 'nokogiri'
module Trackman
  module Urls
    module HtmlParser
      include CssParser
      
      def parse html
        doc = Nokogiri::HTML(html)
        (img(doc) + js(doc) + css(doc) + parse_css(html)).uniq
      end
      
      def img doc
        imgs = refine(doc.css('img'), 'src')
        icons = refine(doc.xpath('//link[@rel="icon"]'), 'href')
        
        imgs + icons
      end
      
      def js doc
        refine(doc.xpath('//script'), 'src')
      end
      def css doc
        refine(doc.xpath('//link[@type="text/css"]'), 'href')
      end

      def refine(paths, node)
        temp = paths.map{|n| n[node].to_s.gsub(/\?[^\?]*$/, '') }
        temp.select{|n| n && n =~ /\w/ && n.internal_path? && !n.embedded? }
      end
    end
  end
end