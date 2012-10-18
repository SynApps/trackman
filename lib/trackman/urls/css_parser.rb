module Trackman
  module Urls
    module CssParser
      @@url ||= /url\(['"]?([^'"\)]+)['"]?\)/
      @@import ||= /url\(['"]?[^'"\)]+['"]?\)/
      
      def parse_css value
        value = value.dup
        clean_comments value
        value.scan(@@import).collect{|x| @@url.match(x)[1]}.select{|x| !x.embedded? }
      end

      def clean_comments value
        value.gsub!(/\/\*.*\*\//m, '')
        value.gsub!(/\<\!\-\-.*\-\-\>/m, '')
      end
    end
  end
end 
