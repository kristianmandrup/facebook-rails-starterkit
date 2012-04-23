module ConfigLoader
  class Yaml
		def initialize path, file_name
			file = file_path path, file_name
			file += '.yml' unless file ~= /\.ya?ml/

			Hashie::Mash.new YAML::load File.open(file)
		end
  	
		protected

  	def config_path
			File.join Rails.root, 'config'
		end

    def file_path path, file_name
    	File.join config_path, path, file_name
    end
	end

	module Delegator
	  def method_missing(m, *args, &block)
	  	raise 'A #loader method must be defined for the LoaderDelegator to work' unless respond_to?(:loader)
	    loader.send(m)
	  end
	end
end