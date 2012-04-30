require 'hashie'

module ConfigLoader
  class Yaml
  	attr_reader :path, :file_name, :ext, :file_path, :root

  	# will try root element if such exists
		def initialize file_path, root = nil
			@file_path = file_path
			@path 		 = File.dirname file_path
			@file_name = File.basename file_path
			@ext 			 = file_name.split(/(ya?ml$)/).last
			@root 		 = (root || file_name.split('.').first).to_s
			@root 		 = nil unless mashie.send(@root)
			@mashie 	 = mashie.send(@root) if @root
		end

		def as_hash
			@as_hash ||= mashie
		end

		def as_yaml
			@as_yaml ||= ::YAML::load File.open(config_file_path)
		end
  	
		protected

		def mashie
			@mashie ||= ::Hashie::Mash.new as_yaml
		end

    def config_file_path
    	@config_file_path ||= File.join(Rails.root.to_s, 'config', file_path)
    end
	end

	module Delegator				
	  def method_missing(m, *args, &block)
	  	raise "A #config method must be defined in the container for ConfigLoader::Delegator, for it to delegate to #config: delegation attempted with #{m}" unless self.respond_to?(:config)
	    config.send(m)
	  end
	end
end