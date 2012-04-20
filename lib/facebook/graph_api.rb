module Facebook
	class GraphApi
		attr_reader :api, :access_token

		def initialize session
			@access_token = session[:access_token]
			@api = Koala::Facebook::GraphAndRestAPI.new(access_token)			
		end

		# also see https://developers.facebook.com/docs/reference/fql/
		# The Facebook Query Language for more efficient complex queries
		# Also enables Multi-query

	  def me
	    @me ||= api.me
	  end

	  # my_id, my_email ...
	  [:id, :email, :name, :first_name, :last_name, :username].each do |attribute|
		  define_method "my_#{attribute}"
		    instance_variable_set(:"@#{attribute}", me.send(attribute)) unless instance_variable_get(:"@#{attribute}")
		  end
		end

	  def my_friends
	  	# or fb.me.friends
	    me.friends
	  end

	  def my_picture
	  	api.get_picture(my_id)
	  end

	  def my_messages
	    api.get_object("/me/statuses", "fields"=>"message")
	  end

	  ## Post

	  def post_on_wall message
	    api.put_wall_post(message)
	  end		
	end
end