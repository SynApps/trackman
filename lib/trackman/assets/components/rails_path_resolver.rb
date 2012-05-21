module Trackman
  module Assets
    module Components  
      module RailsPathResolver
        
        #way 2
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
          path = RailsPathResolver.old_translate(url, parent_url)

          parts = path.split('/')
          parts.insert(0, 'public') if parts.first != 'public'

          parts.join('/')
        end
      end
    end
  end
end