require 'rails/generators'
module Trackman
  class ControllerGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    argument :controller_name, :type => :string, :default => 'errors'
   
    @@actions = ['not_found', 'error', 'maintenance', 'maintenance_error']
    @@routes = {'not-found' => 'not_found', 'error' => 'error', 'maintenance' => 'maintenance', 'maintenance-error' => 'maintenance_error'}

    def create_controller
      template "controller_layout.rb.erb", "app/controllers/#{controller_name}_controller.rb"
    end

    def create_views
      create_views_for(:erb)
    end
    
    def create_routes
      @@routes.each do |k, v|
        route "match \"/#{k}\", :to => \"#{controller_name}##{v}\""
      end
    end
    
    protected
      def create_views_for(engine)
        view_folder = "app/views/#{controller_name}"
        layout = "view_layout.html.#{engine}"

        @@actions.each do |n|
          template layout, "#{view_folder}/#{n}.html.#{engine}"
        end
      end
  end
end