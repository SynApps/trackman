module Trackman
  module Assets
    module Components
      module BundledAsset
        include Hashable
        
        def env
          @@env ||= ::Rails.application.assets.index
        end
         
        def data
          result = (@bundled ||= init_data)

          return super if result.nil? || result.length == 0
          result
        end

        def init_data
          begin          
            return env[env.attributes_for(path.realpath).pathname].to_s
          rescue
            return nil
          end
        end

      end
    end
  end
end