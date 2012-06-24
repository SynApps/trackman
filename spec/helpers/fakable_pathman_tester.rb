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
    
    RemoteAsset.class_eval do
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

    RemoteAsset.class_eval do
      singleton_class = class << self; self; end
      singleton_class.instance_eval do
        alias_method :get_attributes, :old_get_attributes  
        remove_method :old_get_attributes
      end
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
      alias :old_rails_defined? :rails_defined?
      alias :old_asset_pipeline_enabled? :asset_pipeline_enabled? 
      
      define_method :rails_defined? do
        true
      end

      define_method :asset_pipeline_enabled? do
        false
      end
    end
  end

  def self.switch_off
    Trackman::Assets::Components::AssetFactory.module_eval do
      alias :rails_defined? :old_rails_defined?
      alias :asset_pipeline_enabled? :old_asset_pipeline_enabled?
      
      remove_method :old_rails_defined?
      remove_method :old_asset_pipeline_enabled?
    end
  end
end