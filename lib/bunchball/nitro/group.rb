module Bunchball
  module Nitro
    class Group < ApiBase

      def self.session
        {:sessionKey => Bunchball::Nitro.session_key}
      end

      def self.get_challenge_progress(group_name, params = {})
        response = post("group.getChallengeProgress", {:groupName => group_name}.merge(params))
        return response['Nitro']['challenges']
      end

      def self.get_users(group_name, params = {})
        response = post("group.getUsers", {:groupName => group_name}.merge(params))
        return response['Nitro']['users']
      end

    end
  end
end