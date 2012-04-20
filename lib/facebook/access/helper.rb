module Facebook
  module Access
    module Helper
      def fb_retrieve_access_token
        session[:access_token] = session[:oauth].get_access_token(params[:code]) if params[:code]
      end    

      def fb_login permissions
        session[:oauth] = Koala::Facebook::OAuth.new(fb_app.id, fb_app.secret, fb_app.url + '/home/callback')
        @auth_url =  session[:oauth].url_for_oauth_code(:permissions=> permissions || fb_app.default_permissions)
      end

      def auth_url
        @auth_url
      end

      def fb_app
        Facebook::App.instance
      end

      def fb_graph
        Facebook::GraphApi.new session
      end

      def fb_my_id
        fb_graph.my_id
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

      # http://acknowledgement.co.uk/post/Decoding-and-Accessing-The-signed_request-Parameter-in-Rails/247
      def decoded_signed_request
        decoder.decode params['signed_request']
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