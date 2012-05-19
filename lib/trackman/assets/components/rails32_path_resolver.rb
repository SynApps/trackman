module Trackman
  module Assets
    module Components  
      module Rails32PathResolver
        extend PathResolver
        
        class << self
          alias old_translate translate
          alias old_parent_of parent_of

          def parent_of(url)
            if url.to_s.include?('assets')
              old_parent_of(url).ascend do |p|
                return p if p.basename.to_s == 'assets'
              end
            else
              return old_parent_of(url)
            end
          end 
        end

        def translate url, parent_url
          path = Rails32PathResolver.old_translate(url, parent_url)

          parts = path.split('/')
          parts.insert(0, 'app') if parts.first == 'assets'

          if parts.first == 'app' && parts[1] == 'assets'
            parts.insert(2, subfolder(parts.last))
          else
            parts.insert(0, 'public') 
          end

          parts.join('/')
        end

        def subfolder(file)
          if file.include?('.js')
            subfolder = "javascripts"
          elsif file.include?('.css')
            subfolder = "stylesheets"
          else 
            subfolder = "images"
          end
          subfolder
        end
      end
    end
  end
end