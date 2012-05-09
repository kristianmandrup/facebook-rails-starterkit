require 'facebook/access/helper'

module Facebook
	module Auth
		module Devise
			include Facebook::Auth::Basic

			# devise path
			def authenticated user = nil
		    message :signed_in
		    sign_in_and_redirect(:user, user || authentication.user)
		  end
		end
	end
end