require 'facebook/access/helper'

module Facebook
  module Auth
    module Basic
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

      def authenticate!
        raise NotImplementedError, "Must be implemented"
      end

      def after_authenticate_new_user user
        raise NotImplementedError, "Must be implemented"
      end      

      def authenticated
        raise NotImplementedError, "Must be implemented"
      end

      # devise path
      def authenticated_user_saved user
        raise NotImplementedError, "Must be implemented"      
      end

      def try_authenticate_user
        current_user ? authenticate_user : authenticate_new_user
      end

      def authenticate_new_user
        authenticate!
        user = new_user.authentications.build(:provider => auth_provider, :uid => fb_my_id)
        user.save ? authenticated(user) : authenticated_user_not_saved
        after_authenticate_new_user(user)
      end

      def authenticate_user
        # fb_login!
        current_user.authentications.create(:provider => auth_provider, :uid => fb_my_id)
        message :success
        redirect_to authentications_url
      end

      def user_authentication_destroyed
        message :destroyed
        redirect_to authentications_url
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

      def current_user_authentication
        @authentication ||= current_user.authentications.find(params[:id])
      end

      def message type
        flash[:notice] = t "#{auth_provider}.auth.#{type}"
      end
    end
  end
end
