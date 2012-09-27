
class ActLikeRails2311
  def self.switch_on
    Trackman::Components::AssetFactory.module_eval do
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
    Trackman::Components::AssetFactory.module_eval do
      alias :rails_defined? :old_rails_defined?
      alias :asset_pipeline_enabled? :old_asset_pipeline_enabled?
      
      remove_method :old_rails_defined?
      remove_method :old_asset_pipeline_enabled?
    end
  end
end