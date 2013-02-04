require 'nokogiri'

module Trackman
  module Scaffold
    module ContentSaver      
      def self.included(base)
        class << base
          attr_accessor :nodes_to_remove, :nodes_to_edit, :text_to_edit, :mappings 
        end
        base.nodes_to_remove = {}
        base.nodes_to_edit = {}
        base.text_to_edit = {}

        if defined?(Rails)
          base.mappings = { :maintenance => '503', :maintenance_error => '503-error', :not_found => '404', :error => '500' }
        else
          base.mappings = {}
        end
        base.extend ClassMethods
      end

      module ClassMethods
        def edit selector, &block
          raise 'block parameter is mandatory' unless block_given?
          nodes_to_edit[selector] = block
        end
        def gsub pattern, replacement
          text_to_edit[pattern] = replacement
        end
        def remove selector, &predicate
          nodes_to_remove[selector] = predicate
        end
      end

      protected
        def remove_default_nodes doc
          nodes = [] 
          nodes = nodes.concat doc.search('script').select{|n| n['src'] && n['src'].include?('/assets') && !n['src'].include?('application') }
          nodes = nodes.concat doc.search('link').select{|n| n['href'] && n['href'].include?('/assets') && !n['href'].include?('application') }
          nodes.each{|n| n.remove }

          doc
        end

        def remove_nodes doc
          self.class.nodes_to_remove.each do |selector, predicate| 
            nodes = doc.search(selector)
            i = 0;
            unless predicate.nil?
              nodes = nodes.select { |n| r = predicate.call(n, i); i +=1;r } 
            end
            
            nodes.each{|n| n.remove }
          end
          doc
        end

        def edit_nodes doc
          self.class.nodes_to_edit.each do |selector, block|
            doc.search(selector).each_with_index { |n, i| block.call(n, i) }
          end
          doc
        end
        def gsub_html text
          self.class.text_to_edit.each do |pattern, replacement|
            text.gsub! pattern, replacement
          end
          text 
        end

        def xslt
          @xslt ||= Nokogiri::XSLT(File.open("#{File.dirname(__FILE__)}/pretty-print.xslt"))
        end
        
        def asset_pipeline_debug_mode?
          Object.const_defined?(:Rails) &&
            Rails.respond_to?(:application) &&
            Rails.application.config.assets.enabled &&
            Rails.application.config.assets.debug
        end 

        def new_content params={:keep_default_nodes => false} 
          html = Nokogiri::HTML(response.body)
          
          edit_nodes html
          remove_default_nodes html unless params[:keep_default_nodes]
          remove_nodes html
          
          html = xslt.apply_to(html).to_s
          gsub_html(html)
        end 

        def render_content 
          response.body = new_content(:keep_default_nodes => asset_pipeline_debug_mode?)
          to_write = self.class.mappings[params[:action].to_sym]
          unless to_write.nil?
            path = "/public/#{to_write}.html"
            File.open(Rails.root.to_s + path, 'w') { |f| f.write(new_content) } 
          end
        end
    end
  end
end
