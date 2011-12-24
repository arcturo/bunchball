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

      def self.get_points_leaders(params = {})
        response = post("site.getPointsLeaders", self.session.merge(params))
        return response['Nitro']['leaders']
      end
    end
  end
end