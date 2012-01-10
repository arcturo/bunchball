module Bunchball
  module Nitro
    class ApiBase
      def self.request_defaults(api_method)
        { :asyncToken => Bunchball::Nitro.async_token, :method => api_method }
      end

      def self.session
        {:sessionKey => Bunchball::Nitro.session_key}
      end

      def self.post(api_method, params = {})
        p "In ApiBase.post('#{api_method}', #{params})"

        # Don't overwrite a :sessionKey we got from the calling User object
        params = params.merge(self.session) unless params.has_key? :sessionKey

        @@response = HTTParty.post(Bunchball::Nitro.endpoint, :body => request_defaults(api_method).merge(params))

        if @@response.code != 200
          raise "There was an error!"
        else
          @@response
        end
      end

      def self.last_response
        @@response
      end

      def self.get(api_method, params = {})    
        # Don't overwrite a :sessionKey we got from the calling User object
        params = params.merge(self.session) unless params.has_key? :sessionKey

        @@response = HTTParty.get(Bunchball::Nitro.endpoint, :body => request_defaults(api_method).merge(params))

        if @@response.code != 200
          raise "There was an error!"
        else
          @@response
        end
      end

      def self.process_error(error_response)

      end
    end
  end
end