require 'facebook/access/helper'

module Facebook
	module Auth
		module Devise
			include Facebook::Access::Helper

			def index
			  @authentications = current_user.authentications if current_user
			end

			# based on OmniAuth 2 railscast
			def create
			  authenticated? ? authenticated : try_authenticate_user
			end

			def destroy
			  current_user_authentication.destroy
			  user_authentication_destroyed
			end

			protected

			def user_authentication_destroyed
			  flash[:notice] = t "#{auth_provider}.auth.destroyed"
			  redirect_to authentications_url
			end

			def current_user_authentication
				@authentication ||= current_user.authentications.find(params[:id])
			end

			def authenticated
		    flash[:notice] = t "#{auth_provider}.auth.signed_in"
		    sign_in_and_redirect(:user, authentication.user)
		  end

			def try_authenticate_user
			 	current_user ? authenticate_user : authenticate_new_user
			end

			def authenticate_user
				# fb_login!
		    current_user.authentications.create(:provider => auth_provider, :uid => fb_my_id)
		    flash[:notice] = t "#{auth_provider}.auth.success"
		    redirect_to authentications_url
		  end

			def authenticate_new_user
				fb_login!
		    user = new_user.authentications.build(:provider => auth_provider, :uid => fb_my_id)
		    user.save ? authenticated_user_saved : authenticated_user_not_saved
		    after_authenticate_new_user(user)
			end

			def after_authenticate_new_user user
			end

			def authenticated_user_saved
	    	flash[:notice] = t "#{auth_provider}.auth.signed_in"
	    	sign_in_and_redirect(:user, user)
	    end

			def authenticated_user_not_saved
	    	redirect_to new_user_registration_url
	    end

	    def authenticated?
				auth_sessions? && authentication
			end

			def authentication
				@authentication ||= Authentication.find_by_provider_and_uid(auth_provider, fb_my_id)
			end

			# override as needed
			def new_user
				User.new
			end			
		end
	end
end