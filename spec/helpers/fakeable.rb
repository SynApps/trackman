class Trackman::Assets::Asset
  alias :old_path= :path=
end

class Fakeable
  def self.switch_on
    Trackman::Assets::Asset.class_eval do
      define_method :path= do |value|
        pre_path = Trackman::Assets::Asset.class_variable_get :@@pre_path
        self.old_path = Pathname.new(pre_path.to_s + value.to_s)
      end
    end
  end
  def self.switch_off
    Trackman::Assets::Asset.class_eval do
      define_method :path= do |value|
        self.old_path = value
      end
    end
  end
end

