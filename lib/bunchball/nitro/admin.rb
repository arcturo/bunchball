module Bunchball
  module Nitro
    class Admin < ApiBase

      def self.create_challenge(name, params = {})
        response = post("admin.createChallenge", self.session.merge({:name => name}).merge(params))
        return response['Nitro']['challenges']
      end
    end
  end
end
