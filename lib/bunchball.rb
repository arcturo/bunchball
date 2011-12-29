$:.unshift(File.dirname(__FILE__))

require 'httparty'

require 'bunchball/nitro/api_base'
require 'bunchball/nitro/actions'
require 'bunchball/nitro/group'
require 'bunchball/nitro/site'
require 'bunchball/nitro/user'

module Bunchball
  VERSION = '1.0.0'

  module Nitro
    class <<self
      attr_accessor :format, :api_key
      attr_writer :session_key

      # Create little accessor methods for each manager class so
      # we can do like Bunchball::Nitro.actions and so on.  Don't
      # hate me because this is beautiful.  And inefficient.
      ['actions'].each do |method_name|
        define_method(method_name) do
          const_get(method_name.capitalize)
        end
      end

      def login(user_id, api_key = nil)
        @api_key ||= api_key
        @session_key ||= authenticate(user_id, api_key)
      end

      def authenticate(user_id, api_key = nil)
        @api_key ||= api_key
        response = HTTParty.post(endpoint, :body => {:method => "user.login", :userId => user_id, :apiKey => api_key || Bunchball::Nitro.api_key})
        response['Nitro']['Login']['sessionKey']
      end

      def login_admin(user_name, password, api_key = nil)
        @api_key ||= api_key
        unless @session_key
          response = HTTParty.post(endpoint, :body => {:method => "admin.loginAdmin", :userId => user_name, :password => password, :apiKey => api_key || Bunchball::Nitro.api_key})
          @session_key = response['Nitro']['Login']['sessionKey']
        end
      end

      def session_key
        @session_key || raise("Not logged in!")
      end

      def async_token=(token)
        @async_token = token
      end

      def async_token
        @async_token || random_async_token
      end

      def random_async_token
        ([rand(10), rand(10), rand(10)] * 3).join("-#{rand(30)}")
      end

      def endpoint=(url)
        @endpoint = url
      end

      def endpoint
        @endpoint || "http://sandbox.bunchball.net/nitro/#{@format || 'json'}"
      end
    end
  end
end
