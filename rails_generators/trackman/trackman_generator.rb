class TrackmanGenerator < Rails::Generator::Base
  def manifest 
    record do |m|
      m.directory('lib/tasks')
      m.file('trackman.rake', 'lib/tasks/trackman.rake')
    end
  end
end