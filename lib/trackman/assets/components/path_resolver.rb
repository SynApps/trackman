module Trackman
  module Assets
    module Components  
      module PathResolver
      	def translate url, parent_url
          raise "parent_url: #{parent_url} is required to be relative" if Pathname.new(parent_url).absolute?

      		url = Pathname.new(url) unless url.is_a? Pathname
      		parent_url = Pathname.new(parent_url) unless parent_url.is_a? Pathname
      		
      		if url.relative?
      			parent = parent_of(parent_url)
      			child = url
      		else
      			parent = working_dir
            s = url.to_s
      			child = Pathname.new(s[1...s.length])
      		end

          (parent + child).relative_path_from(working_dir).to_s
      	end

      	def working_dir
      		Pathname.new Dir.pwd
      	end

      	def parent_of(url)
      		(working_dir + url).parent
      	end
      end
    end
  end
end

