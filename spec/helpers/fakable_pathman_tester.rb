class FakablePathManTester  
  @@modules = [PathResolver, Rails32PathResolver, RailsPathResolver]
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


module Trackman
  module Assets
    module Components
      module AssetFactory
        alias :old_asset_pipeline_enabled? :asset_pipeline_enabled?
      end
    end
  end
end

class ActLikeRails32
  def self.switch_on
    Trackman::Assets::Components::AssetFactory.module_eval do
      alias :old_asset_pipeline_enabled? :asset_pipeline_enabled?
      
      define_method :asset_pipeline_enabled? do
        true
      end
    end
  end

  def self.switch_off
    Trackman::Assets::Components::AssetFactory.module_eval do
      alias :asset_pipeline_enabled? :old_asset_pipeline_enabled?
      remove_method :old_asset_pipeline_enabled?
    end
  end
end

class ActLikeRails2311
  def self.switch_on
    Trackman::Assets::Components::AssetFactory.module_eval do
      alias :old_uses_rails? :uses_rails?
      alias :old_uses_rails32? :uses_rails32?
      
      define_method :uses_rails? do
        true
      end

      define_method :uses_rails32? do
        false
      end
    end
  end

  def self.switch_off
    Trackman::Assets::Components::AssetFactory.module_eval do
      alias :uses_rails? :old_uses_rails?
      alias :uses_rails32? :old_uses_rails32?
      remove_method :old_uses_rails32?
    end
  end
end