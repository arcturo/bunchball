module Bunchball
  module Nitro
    class Group < ApiBase

      def self.session
        {:sessionKey => Bunchball::Nitro.session_key}
      end

      def self.get_challenge_progress(group_name, params = {})
        response = post("group.getChallengeProgress", {:groupName => group_name}.merge(params))
        response = Response.new(response, 'challenges')
        challenges = []
        [response.payload['Challenge']].compact.each do |challenge|
          challenges << Challenge.new(challenge)
        end
        response.payload = challenges
        response
      end

      def self.get_users(group_name, params = {})
        response = post("group.getUsers", {:groupName => group_name}.merge(params))
        Response.new(response, 'users')
      end

    end
  end
end