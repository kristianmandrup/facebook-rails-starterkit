module Facebook
	def app
		Facebook::App.instance
	end

	def app= app
		app.fb_app = app
	end
		
	class App
		include Singleton

		attr_accessor :fb_app

		def id
			fb_app.id
		end

		def secret_key
			fb_app.secret
		end

		def site_url
			fb_app.url
		end		

	  def fb_default_permissions
	    fb_app.default_permissions
	  end
	end
end