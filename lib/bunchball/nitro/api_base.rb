module Bunchball
  module Nitro
    class ApiBase
      def self.request_defaults(api_method)
        { :asyncToken => Bunchball::Nitro.async_token, :sessionKey => Bunchball::Nitro.session_key, :method => api_method }
      end
      
      def self.post(api_method, params = {})
        pp "In ApiBase.post('#{api_method}', #{params})"
        @_response = HTTParty.post(Bunchball::Nitro.endpoint, :body => request_defaults(api_method).merge(params))
        
        if @_response.code != 200
          raise "There was an error!"
        else
          pp "*"*80
          pp @_response.code
          pp @_response.class
          pp "*"*80
          pp @_response
          pp "*"*80
          @_response
        end
      end

      def self.last_response
        @_response
      end

      def self.get(api_method, params = {})    
        @_response = HTTParty.get(Bunchball::Nitro.endpoint, :body => request_defaults(api_method).merge(params))

        if @_response.code != 200
          raise "There was an error!"
        else
          @_response
        end
      end

      def self.process_error(error_response)

      end
    end
  end
end