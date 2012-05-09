module Facebook
  module Access
    module Helper
      def fb_retrieve_access_token
        session[:access_token] = has_code? ? access_token_from_code : cookies_access_token
        log! 'session-access_token', session[:access_token]
      end    

      def access_token_from_code
        session[:oauth].get_access_token(code) 
      end        

      def fb_login permissions = nil
        session[:oauth] = oauth_api.new(fb_app.identifier, fb_app.secret, fb_app.site_url + fb_app.callback_path)                
        log! 'session-oath', session[:oauth]
      end

      def fb_login! permissions = nil
        fb_login permissions
        redirect_to auth_url        
      end

      def auth_url 
        @auth_url ||= session[:oauth].url_for_oauth_code(:permissions=> permissions || fb_app.default_permissions)
      end

      def cookies_access_token
        @cookies_access_token ||= session[:oauth].get_user_info_from_cookies(cookies)
      end

      def user_access_token
        @user_access_token ||= user_cookie_info["access_token"]
        log! 'user cookie access_token', @user_access_token
        @user_access_token
      end

      def real_time_updates
        @updates = Facebook.updates_api.new(:app_id => fb_app.identifier, :secret => fb_app.secret)
      end

      def auth_url
        @auth_url
      end

      def fb_app
        Facebook::App.instance
      end

      def fb_graph
        @fb_graph ||= graph_api.new session
        log! 'fb_graph', @fb_graph
        @fb_graph
      end

      def fb_my_id
        @fb_my_id ||= fb_graph.my_id
      end

      def auth_provider
        params[:provider] || 'facebook'
      end

      # for FB Registration plugin
      # see https://developers.facebook.com/docs/plugins/registration/
      def signed_request
        Hashie::Mash.new decoded_signed_request
      end

      def registration
        signed_request.registration
      end  

      protected

      def has_code?
        params[:code]
      end

      def code
        params[:code]
      end

      def auth_sessions?
        session[:access_token] && session[:oauth]
      end

      def log! title, msg
        msg = msg.kind_of?(String) ? msg : msg.inspect
        puts "#{title}: #{msg}" if auth_logging?
      end

      def auth_logging?
        Facebook::Starterkit.logging?
      end

      def oauth_api
        Koala::Facebook::OAuth
      end

      # Custom GraphAPI wrapper
      def graph_api
        Facebook::GraphApi
      end

      # http://acknowledgement.co.uk/post/Decoding-and-Accessing-The-signed_request-Parameter-in-Rails/247
      def decoded_signed_request
        @decoded_signed_request ||= decoder.decode params['signed_request']
        log! 'decoded_signed_request', @decoded_signed_request
        @decoded_signed_request
      end

      def decoder
        @decoder ||= Decoder.new
      end

      class Decoder
        def base64_url_decode str
         encoded_str = str.gsub('-','+').gsub('_','/')
         encoded_str += '=' while !(encoded_str.size % 4).zero?
         Base64.decode64(encoded_str)
        end

        def decode str
         encoded_sig, payload = str.split('.')
         data = ActiveSupport::JSON.decode base64_url_decode(payload)
        end
      end
    end
  end
end