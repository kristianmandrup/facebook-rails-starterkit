module Facebook
  module Access
    module Omniauth
      def omniauth
        request.env["omniauth.auth"]
      end

      def auth_provider
        omniauth['provider']
      end

      def user_id
        omniauth['uid']
      end
    end
  end
end