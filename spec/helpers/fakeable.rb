class Trackman::Assets::Asset
  alias :old_path= :path=
end
module Trackman::Assets::Components::Conventions
  alias :old_maintenance_path :maintenance_path
  alias :old_error_path :error_path 
end
module Trackman::Assets::Components::CompositeAsset
  alias :old_to_path :to_path
end

class Fakeable
  def self.switch_on(pre_path)
    Trackman::Assets::Asset.class_eval do
      define_method :path= do |value|
        self.old_path = Fakeable.setup(pre_path, value) 
      end
    end

    Trackman::Assets::Components::Conventions.module_eval do
      define_method :maintenance_path do
        Fakeable.setup pre_path, 'public/503.html'
      end

      define_method :error_path do
        Fakeable.setup pre_path, 'public/503-error.html'
      end
    end

    #Trackman::Assets::Components::CompositeAsset.module_eval do
    #  define_method :to_path do |str_path|
        # TODO: evil way to get it done, it's going to break when the implementation changes but for now...

    #    Fakeable.setup(pre_path, old_to_path(str_path)) do |p|  
          # index = p.index(pre_path) + pre_path.size 
          # #puts "PATH p: #{p}"
          # p.insert(index, path.parent.to_s)  
          # p
    #    end
    #  end
    #end
  end

  def self.setup(pre_path, path)
    p = ""
    unless path.to_s.include? pre_path
      p << pre_path.to_s.dup
      p << '/' if p[-1] != '/' && path[0] != '/'
    end
    p << path.to_s.dup    
    Pathname.new p
  end

  def self.switch_off
    Trackman::Assets::Asset.class_eval do
      define_method :path= do |value|
        self.old_path = value
      end
    end

    Trackman::Assets::Components::Conventions.module_eval do
      define_method :maintenance_path do
        old_maintenance_path
      end
      define_method :error_path do
        old_error_path
      end
    end

    #Trackman::Assets::Components::CompositeAsset.module_eval do
    #  define_method :to_path do |val|
    #    old_to_path(val)
    #  end
    #end
  end
end

