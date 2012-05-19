module Trackman
  module Assets
    module Components
      module Conventions
        Asset = Trackman::Assets::Asset
        
        def maintenance_path
          Pathname.new 'public/503.html'
        end
        def error_path
          Pathname.new 'public/503-error.html'
        end  
        def maintenance_page
          Asset.create(:path => maintenance_path)
        end
        def error_page
          Asset.create(:path => error_path)
        end 
      end
    end
  end
end

