require 'facebook/app'
require 'facebook/graph_api'
require 'facebook/access/helper'
require 'facebook/access/omniauth'

require 'facebook/auth/devise' if defined?(Devise)

module Facebook
  module Starterkit
    class << self
      attr_accessor :logging

      def logging_on!
        @logging = true
      end

      def logging_off!
        @logging = false
      end

      def logging?
        @logging
      end
    end
  end
end