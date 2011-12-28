module Bunchball
  module Nitro
    class Site < ApiBase

      def self.session
        {:sessionKey => Bunchball::Nitro.session_key}
      end

      # TODO: Figure out why these all just return true instead of the lists of
      # things they should return.
      def self.get_action_feed(api_key = nil, params = {})
        response = post("site.getActionFeed", params.merge(:apiKey => api_key || Bunchball::Nitro.api_key))
        return response['Nitro']['items']
      end

      def self.get_action_leaders(params = {})
        response = post("site.getActionLeaders", self.session.merge(params))
        return response['Nitro']['actions']
      end

      def self.get_action_target_leaders(params = {})
        response = post("site.getActionTargetLeaders", self.session.merge(params))
        return response['Nitro']['targets']
      end

      def self.get_challenge_leaders(params = {})
        response = post("site.getChallengeLeaders", self.session.merge(params))
        return response['Nitro']['challenges']
      end

      def self.get_points_leaders(params = {})
        response = post("site.getPointsLeaders", self.session.merge(params))
        return response['Nitro']['leaders']
      end

      # TODO: Sample request in API for this call shows a :duration param, but
      # docs just above it don't include one.
      def self.get_recent_actions(params = {})
        response = post("site.getRecentActions", self.session.merge(params))
        return response['Nitro']['actions']
      end

      def self.get_recent_challenges(params = {})
        response = post("site.getRecentChallenges", self.session.merge(params))
        return response['Nitro']['challenges']
      end

      def self.get_recent_updates(criteria, params = {})
        response = post("site.getRecentUpdates", self.session.merge(:criteria => criteria).merge(params))
        return response['Nitro']['updates']
      end

    end
  end
end