module Facebook
	module Auth
		include Facebook::Helper

		module Devise
			def index
			  @authentications = current_user.authentications if current_user
			end

			# based on OmniAuth 2 railscast
			def create
			  authentication = Authentication.find_by_provider_and_uid(auth_provider, fb_my_id)
			  if authentication
			    flash[:notice] = t "#{auth_provider}.auth.signed_in"
			    sign_in_and_redirect(:user, authentication.user)
			  elsif current_user
			    current_user.authentications.create(:provider => 'facebook', :uid => fb_my_id)
			    flash[:notice] = t "#{auth_provider}.auth.success"
			    redirect_to authentications_url
			  else			    
			    new_user.authentications.build(:provider => omniauth ['provider'], :uid => omniauth['uid'])
			    if user.save
			    	flash[:notice] = t "#{auth_provider}.auth.signed_in"
			    	sign_in_and_redirect(:user, user)
			    else				
			    	# must register email
		  			redirect_to new_user_registration_url
			  	end	    
			  end
			end

			def destroy
			  @authentication = current_user.authentications.find(params[:id])
			  @authentication.destroy
			  flash[:notice] = t "#{auth_provider}.auth.destroyed"
			  redirect_to authentications_url
			end

			protected

			# override as needed
			def new_user
				User.new
			end			
		end
	end
end