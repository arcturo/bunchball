module Bunchball
  module Nitro
    class Admin < ApiBase

      def self.create_action_tag(name, params = {})
        response = post("admin.createActionTag", params.merge(:name => name))
      end

      def self.create_challenge(name, params = {})
        response = post("admin.createChallenge", self.session.merge({:name => name}).merge(params))
        return response['Nitro']['challenges']
      end

      def self.get_action_tags(params = {})
        response = post("admin.getActionTags", params)
        return response['Nitro']['tags']['Tag']
      end
    end
  end
end
