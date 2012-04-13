module Trackman
  module Assets
    module Components
      module CompositeAsset
        protected
          def to_assets paths
            array = []
            paths.select{|p| internal? p }.each do |p| 
              asset = Asset.create(:path => to_path(p))  
              array << asset 
                
              if asset.respond_to? :assets
                not_inside = asset.assets.select{|a| !array.include?(a) } 
                not_inside.each do |a| 
                  array << a 
                end
              end
            end
            array
          end

          def to_path(str_path)
            return Pathname.new str_path if File.exist? str_path
            Pathname.new "#{path.parent}/#{str_path}"
          end 
          def internal? path
            path !~ /(\/|http)/
          end       
      end
    end
  end
end