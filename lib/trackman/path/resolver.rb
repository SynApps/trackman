module Trackman
  module Path  
    module Resolver
    	def translate url, parent_url
        raise "parent_url: #{parent_url} is required to be relative" if Pathname.new(parent_url).absolute?

    		url = Pathname.new(url) unless url.is_a? Pathname
    		parent_url = Pathname.new(parent_url) unless parent_url.is_a? Pathname
    		
    		if url.relative?
    			parent = parent_of(parent_url)
    			child = url
    		else
    			parent = working_dir + 'public/'
    			child = Pathname.new(url.to_s[1..-1])
    		end
        relative_path = (parent + child).relative_path_from(working_dir).to_s
        file_exist?(relative_path) ? relative_path : nil
      end
      def file_exist? path
        File.exists? path
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

