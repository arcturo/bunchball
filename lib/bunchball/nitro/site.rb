module Bunchball
  module Nitro
    class Site < ApiBase

      def self.session
        {:sessionKey => Bunchball::Nitro.session_key}
      end

      def self.add_users_to_group(user_ids, group_name, params = {})
        response = post("site.addUsersToGroup", {:userIds => user_ids, :groupName => group_name}.merge(params))
        Response.new(response, 'groupUsers')
      end

      # API Returns either true (if there are no actions to report but request was valid),
      # or a hash with 'items' as its only key. However, that key's value may be a single hash,
      # or an array of hashes, depending on whether there are one or multiple actions to report.
      def self.get_action_feed(params = {})
        response = post("site.getActionFeed", {:apiKey => Bunchball::Nitro.api_key}.merge(params))
        Response.new(response, 'items')
      end

      def self.get_action_leaders(criteria, tags, params = {})
        response = post("site.getActionLeaders", {:criteria => criteria, :tags => tags}.merge(params))
        Response.new(response, 'actions')
      end

      def self.get_action_target_leaders(criteria, tag, params = {})
        response = post("site.getActionTargetLeaders", self.session.merge(:criteria => criteria, :tag => tag).merge(params))
        Response.new(response, 'targets')
      end

      def self.get_catalog(params = {})
        response = post("site.getCatalog", params)
        Response.new(response, 'CatalogRecord')
      end

      def self.get_catalog_item(item_id, params = {})
        response = post("site.getCatalogItem", {:itemId => item_id}.merge(params))
        response = Response.new response
        response.payload = response.nitro['CatalogRecord']['catalogItems']['CatalogItem'] rescue nil
        response
      end

      def self.get_challenge_leaders(params = {})
        response = post("site.getChallengeLeaders", self.session.merge(params))
        Response.new(response, 'challenges')
      end

      def self.get_group_action_leaders(tags, params = {})
        response = post("site.getGroupActionLeaders", {:tags => tags}.merge(params))
        Response.new(response, 'groupLeaders')
      end

      def self.get_group_points_leaders(params = {})
        response = post("site.getGroupPointsLeaders", params)
        Response.new(response, 'groupLeaders')
      end

      def self.get_levels(params = {})
        response = post("site.getLevels", params)
        response = Response.new response
        response.payload = response.nitro['siteLevels']['SiteLevel']
        response
      end

      def self.get_points_leaders(params = {})
        response = post("site.getPointsLeaders", self.session.merge(params))
        Response.new(response, 'leaders')
      end

      # TODO: Sample request in API for this call shows a :duration param, but
      # docs just above it don't include one.
      def self.get_recent_actions(params = {})
        response = post("site.getRecentActions", self.session.merge(params))
        Response.new(response, 'actions')
      end

      def self.get_recent_challenges(params = {})
        response = post("site.getRecentChallenges", self.session.merge(params))
        Response.new(response, 'challenges')
      end

      def self.get_recent_updates(criteria, params = {})
        response = post("site.getRecentUpdates", self.session.merge(:criteria => criteria).merge(params))
        Response.new(response, 'updates')
      end

      def self.remove_users_from_group(user_ids, group_name, params = {})
        response = post("site.removeUsersFromGroup", {:userIds => user_ids, :groupName => group_name}.merge(params))
        Response.new(response, 'groupUsers')
      end
    end
  end
end