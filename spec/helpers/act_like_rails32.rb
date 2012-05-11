require 'helpers/fakeable'

module Trackman
  module Assets
    module Components
      module AssetFactory
        alias :old_uses_rails32? :uses_rails32?
      end
    end
  end
end

class ActLikeRails32
  def self.switch_on(pre_path)
    Trackman::Assets::Components::AssetFactory.module_eval do
      define_method :uses_rails32? do
        true
      end
    end
    Fakeable.switch_on(pre_path)
  end
  def self.switch_off
    Trackman::Assets::Components::AssetFactory.module_eval do
      define_method :uses_rails32? do
        old_uses_rails32?
      end
    end
    Fakeable.switch_off
  end
end
