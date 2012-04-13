module Trackman
  module Assets
    module Components
      module CompositeAsset
        
        def assets
          my_assets = []

          children_paths.select{|p| p.internal_path? }.each do |p| 
            asset = Asset.create(:path => to_path(p))  
            my_assets << asset 
              
            if asset.respond_to? :assets
              not_inside = asset.assets.select{|a| !my_assets.include?(a) } 
              not_inside.each do |a|
                my_assets << a
              end
            end
          end
          my_assets
        end
        
        protected
          def to_path(str_path)
            return Pathname.new str_path if File.exist? str_path
            Pathname.new "#{path.parent}/#{str_path}"
          end    
      end
    end
  end
end

class String
  def internal_path? 
    self !~ /^http/
  end 
end