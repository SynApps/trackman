
class TrackmanControllerGenerator < ::Rails::Generator::Base
  def initialize runtime_args, runtime_options = {}
    self.controller_name = options[:controller_name] || 'errors'
    super
  end

  attr_accessor :controller_name

  @@actions = ['not_found', 'error', 'maintenance', 'maintenance_error']
  @@routes = {'404' => 'not_found', '500' => 'error', 'maintenance' => 'maintenance', 'maintenance-error' => 'maintenance_error'}

  def manifest # this method is default entrance of generator
    puts route_doc false
    record do |m|
      m.template 'controller_layout.rb.erb', "app/controllers/#{controller_name}_controller.rb"
      create_views_for(:erb, m)
    end
  end

  protected
    def create_views_for(engine, m)
      view_folder = "app/views/#{controller_name}"
      layout = "view_layout.html.#{engine}"

      m.directory(view_folder)
      @@actions.each do |n|
        m.template layout, "#{view_folder}/#{n}.html.#{engine}"
      end
    end

    def route_doc show_as_comments = false
      char = show_as_comments ? '#' : ''
"\n#{char} Don't forget to add the routes in config/routes.rb\n#{char} ------
#{char} map.not_found '/not_found', :controller => '#{controller_name}', :action => :not_found
#{char} map.error '/error', :controller => '#{controller_name}', :action => :error
#{char} map.maintenance '/maintenance', :controller => '#{controller_name}', :action => :maintenance
#{char} map.maintenance_error '/maintenance-error', :controller => '#{controller_name}', :action => :maintenance_error
#{char} ------\n\n"
    end
end