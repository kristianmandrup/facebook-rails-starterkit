module ConfigLoader
  class Yaml
		def initialize path, file_name
			@path = path

			file_name += '.yml' unless file_name ~= /\.ya?ml/
			@file_name = file_name  
			
			Hashie::Mash.new yaml
		end
  	
		protected

		def yaml
			@yaml ||= YAML::load File.open(file_path)
		end

  	def config_path
			@config_path ||= File.join Rails.root, 'config'
		end

    def file_path
    	@file_path = File.join config_path, path, file_name
    end
	end

	module Delegator				
	  def method_missing(m, *args, &block)
	  	raise 'A #config method must be defined for the LoaderDelegator to work' unless respond_to?(:config)
	    config.send(m)
	  end
	end
end