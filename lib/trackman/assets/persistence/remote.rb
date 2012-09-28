require 'rest-client'
require 'json'

module Trackman
  module Assets
    module Persistence
      module Remote
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          def server_url
            @server_url ||= ENV['TRACKMAN_URL']
          end
          def site
            @site ||= "#{server_url}/assets"
          end

          def find id
            response = RestClient.get "#{site}/#{id}"
          
            body = Hash[JSON.parse(response).map{ |k, v| [k.to_sym, v] }]
    
            create(body)
          end

          def all
            get_attributes.map{ |r| create(r) }.sort
          end

          def get_attributes
            JSON.parse(RestClient.get site).map{|r| Hash[r.map{ |k, v| [k.to_sym, v] }] }
          end
        end
        
        def insert
          response = RestClient.post self.class.site, build_params, :content_type => :json, :accept => :json, :ssl_version => 'SSLv3'
          path = response.headers[:location]
          @id = path[/\d+$/].to_i
        end

        def update
          RestClient.put "#{self.class.site}/#{id}", build_params, :content_type => :json, :accept => :json, :ssl_version => 'SSLv3'
        end  

        def delete
          response = RestClient.delete "#{self.class.site}/#{id}"
          true
        end
      end
    end
  end
end