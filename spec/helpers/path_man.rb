module PathMan
	def translate url, parent_url
		raise "parent_url: #{parent_url} is required to be relative" if Pathname.new(parent_url).absolute?

		parent_url = strip_pre_path parent_url.to_s

		url = Pathname.new(url) unless url.is_a? Pathname
		parent_url = Pathname.new(parent_url) unless parent_url.is_a? Pathname
		
		if url.relative?
			parent = parent_of(parent_url)
			puts parent
			child = url
		else
			parent = working_dir
			s = url.to_s
			child = Pathname.new(s[1...s.length])
		end
	  
	  prepath + (parent + child).relative_path_from(working_dir).to_s
	end

	def strip_pre_path path
		path.gsub(prepath, "")
	end

	def working_dir
		Pathname.new Dir.pwd + prepath
	end

	def prepath
		''
	end

	def parent_of(url)
		(working_dir + url).parent
	end
end

module Rails32PathMan
	extend PathMan
	
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
		puts "parent_url #{parent_url}, url #{url}"

		path = Rails32PathMan.strip_pre_path Rails32PathMan.old_translate(url, parent_url)

		parts = path.split('/')
		parts.insert(0, 'app') if parts.first == 'assets'

		if parts.first == 'app' && parts[1] == 'assets'
			parts.insert(2, subfolder(parts.last))
		else
			parts.insert(0, 'public')
		end

		Rails32PathMan.prepath + parts.join('/')
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