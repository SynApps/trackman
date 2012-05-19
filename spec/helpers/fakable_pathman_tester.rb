class FakablePathManTester  
  @@modules = [PathMan, Rails32PathMan]
  Conventions = Trackman::Assets::Components::Conventions

  def self.switch_on prepath
    @@modules.each do |m| 
      m.module_eval do
        alias real_translate translate  
        alias real_working_dir working_dir if method_defined? :working_dir

        define_method :translate do |url, parent_url|
          parent = parent_url.to_s.dup
          parent.slice!(prepath)
          prepath + real_translate(url, parent)
        end

        if method_defined? :working_dir
          define_method :working_dir do
            real_working_dir + prepath
          end
        end
      end
    end

    Conventions.module_eval do 
      alias :real_maintenance_path :maintenance_path 
      alias :real_error_path :error_path
       
       define_method :maintenance_path do
         Pathname.new(prepath + real_maintenance_path.to_s)
       end

       define_method :error_path do
         Pathname.new(prepath + real_error_path.to_s)
       end
    end 
  end

  def self.switch_off
    @@modules.each do |m| 
      m.module_eval do
        alias :translate :real_translate
        remove_method :real_translate

        if method_defined? :working_dir
          alias :working_dir :real_working_dir
          remove_method :real_working_dir
        end
      end
    end
    
    Conventions.module_eval do
      alias :maintenance_path :real_maintenance_path 
      alias :error_path :real_error_path

      remove_method :real_maintenance_path
      remove_method :real_error_path
    end 
  end
end
