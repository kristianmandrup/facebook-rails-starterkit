module ConfigLoader
  class Yaml
  	attr_reader :path, :file_name, :ext, :file_path, :root, :hash

  	# will try root element if such exists
		def initialize file_path, root = nil
			@file_path = file_path
			@path 		 = File.dirname file_path
			@file_name = File.basename file_path
			@ext 	= file_name.split(/(ya?ml$)/).last
			@root = root || file_name.split('.').first
			
			hash = Hashie::Mash.new yaml
			@hash = hash.send(root) || hash
		end
  	
		protected

		def yaml
			@yaml ||= YAML::load File.open(config_file_path)
		end

    def config_file_path
    	@config_file_path ||= Rails.root.join('config', file_path)
    end
	end

	module Delegator				
	  def method_missing(m, *args, &block)
	  	raise "A #config method must be defined in the container for ConfigLoader::Delegator, for it to delegate to #config: delegation attempted with #{m}" unless self.respond_to?(:config)
	    config.send(m)
	  end
	end
end