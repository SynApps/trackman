class FakablePathManTester  
  @@modules = [PathResolver, Rails32PathResolver, RailsPathResolver]
  Conventions = Trackman::Assets::Components::Conventions

  def self.switch_on prepath
    override_remote_assets prepath
    override_conventions prepath
    override_resolvers prepath
  end

  def self.switch_off
    reset_resolvers
    reset_conventions
    reset_remote_assets
  end

  def self.override_resolvers prepath
    
    PathResolver.module_eval do
      alias real_working_dir working_dir

      define_method :working_dir do
        real_working_dir + prepath
      end
    end
   
    @@modules.each do |m| 
      m.module_eval do
        alias real_translate translate  
        
        define_method :translate do |url, parent_url|
          parent = parent_url.to_s.dup
          parent.slice!(prepath)
          prepath + real_translate(url, parent)
        end
      end
    end
  end

  def self.override_conventions prepath
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

  def self.override_remote_assets prepath
    RemoteAsset.class_eval do
      alias_method :old_build_params, :build_params
      define_method :build_params do
        params = old_build_params
        path = params[:asset][:path]
        path.slice! prepath

        params 
      end

      singleton_class = class << self; self; end
      singleton_class.instance_eval do
        alias_method :old_get_attributes, :get_attributes  
        
        define_method :get_attributes do
          old_get_attributes.map do |h|
            my_hash = h.dup
            my_hash[:path] = prepath + h[:path] unless h[:path].start_with? prepath
            my_hash
          end
        end
      end
    end
  end

  def self.reset_resolvers
    PathResolver.module_eval do    
      alias :working_dir :real_working_dir
      remove_method :real_working_dir
    end

    @@modules.each do |m| 
      m.module_eval do
        alias :translate :real_translate
        remove_method :real_translate
      end
    end
    Rails32PathResolver.class_variable_set(:@@sprockets, nil)
  end

  def self.reset_conventions
    Conventions.module_eval do
      alias :maintenance_path :real_maintenance_path 
      alias :error_path :real_error_path

      remove_method :real_maintenance_path
      remove_method :real_error_path
    end
  end

  def self.reset_remote_assets
    RemoteAsset.class_eval do
      alias_method :build_params, :old_build_params
      remove_method :old_build_params
      
      singleton_class = class << self; self; end
      singleton_class.instance_eval do
        alias_method :get_attributes, :old_get_attributes  
        remove_method :old_get_attributes
      end
    end
  end
end
