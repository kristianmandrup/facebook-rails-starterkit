require 'singleton'

module Facebook
	def self.app
		Facebook::App.instance
	end

	def self.app= an_app
		app.fb_app = an_app
	end
		
	class App
		include Singleton

		attr_accessor :fb_app

		delegate :identifier, :secret, :site_url, 
						 :callback_path, :to => :fb_app #, :allow_nil => true

		# comma separated list
		# 'email,user_birthday,read_stream
		def permissions
			@permissions ||= fb_app.permissions.flatten.join(',')
		end
	end
end