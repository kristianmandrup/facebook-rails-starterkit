module Facebook
	def self.api
		::Koala::Facebook::API
	end

	def self.updates_api
		::Koala::Facebook::RealtimeUpdates
	end

	class GraphApi
		attr_reader :fb_api, :access_token

		def initialize session
			@access_token = session[:access_token]
			log! 'GraphApi access_token', @access_token
			@fb_api =  ::Facebook.api.new(access_token)			
		end

		def api
			@api ||= fb_api
		end

		def self.clazz
    	::Facebook.api
    end

		# also see https://developers.facebook.com/docs/reference/fql/
		# The Facebook Query Language for more efficient complex queries
		# Also enables Multi-query

	  def me
	    @me ||= ::Hashie::Mash.new api.get_object('me')
	  end

	  # my_id, my_email ...
	  [:id, :email, :name, :first_name, :last_name, :username].each do |attribute|
		  define_method "my_#{attribute}" do
		    instance_variable_set(:"@#{attribute}", me.send(attribute)) unless instance_variable_get(:"@#{attribute}")
		  end
		end

	  def my_friends
	  	# or fb.me.friends
	    me.friends
	  end

	  def my_picture
	  	api.get_picture my_id
	  end

	  def my_messages
	    api.get_object "/me/statuses", "fields"=>"message"
	  end

	  ## Post

	  def post_on_wall message
	    api.put_wall_post message
	  end

	  protected

  	def log! title, msg
      msg = msg.kind_of?(String) ? msg : msg.inspect
      puts "#{title}: #{msg}" if logging?
    end

    def logging?
      Facebook::Starterkit.logging?
    end
	end
end