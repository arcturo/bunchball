module Bunchball
  module Nitro
    class User < ApiBase
      attr_accessor :level, :session_key, :user_id

      def initialize(user_id)
        @user_id = user_id
      end

      def login
        @session_key = Bunchball::Nitro.authenticate(user_id)
      end

      def session
        login unless @session_key
        {:sessionKey => @session_key}
      end

      def self.accept_friend(user_id, friend_id, params = {})
        response = post("user.acceptFriend", {:userId => user_id, :friendId => friend_id}.merge(params))
        return Response.new(response)
      end

      def accept_friend(friend_id, params = {})
        response = User.accept_friend(@user_id, friend_id, session.merge(params))
      end

      def self.award_challenge(user_id, challenge, params = {})
        response = post("user.awardChallenge", {:userId => user_id, :challenge => challenge}.merge(params))
        Response.new(response, 'Achievements')
      end

      def award_challenge(challenge, params = {})
        User.award_challenge(@user_id, challenge, session.merge(params))
      end

      def self.broadcast(user_id, message, params = {})
        response = Response.new post("user.broadcast", {:userId => user_id, :message => message}.merge(params))
        if response.nitro['SocialLink'] == true    # actual true, not a 'truthy' value
          response.payload = []
        else
          response.payload = response.nitro['SocialLink']
        end
        return response
      end

      def broadcast(message, params = {})
        User.broadcast(@user_id, message, session.merge(params))
      end

      # Return values not documented in Wiki for this method, so here
      # they are for now:

      # {'Nitro' =>
      # { "res" => "ok",
      #   "AvatarRecord" => {
      #     "items" => {
      #       "CatalogItem" => [
      #         { "passExtraData" => "0", "price"=>"0", "countRemaining"=>"-1", "name"=>"DO NOT REMOVE",
      #           "zOrder"=>"80", "createTime"=>"1318020864", "category"=>"TofooHead", "ownedCount"=>"0",
      #           "background"=>"0", "designer"=>"", "categoryIds"=>"2806768",
      #           "fullUrl"=>"http://assets.bunchball.com/catalog/TofooHead.swf", "orders"=>"", "tags"=>"",
      #           "id"=>"30019446", "color1"=>"", "customData"=>"", "lastUpdated"=>"1241111552", "doCallback"=>"0",
      #           "thumbUrl"=>"http://assets.bunchball.com/catalog/TofooHead.swf", "canUnselect"=>"false",
      #           "color2"=>"", "catalogName"=>"DEFAULT_AVATAR", "maxOwnedCountPerUser"=>"-1", "description"=>"",
      #           "realItem"=>"0", "catalogItemId"=>"30019446", "pointCategoryId"=>"283426"
      #         },
      #         { "passExtraData"=>"0", "price"=>"0", "countRemaining"=>"-1", "name"=>"DO NOT REMOVE",
      #           "zOrder"=>"40", "createTime"=>"1318020864", "category"=>"TofooBody", "ownedCount"=>"0",
      #           "background"=>"0", "designer"=>"", "categoryIds"=>"2806770",
      #           "fullUrl"=>"http://assets.bunchball.com/catalog/TofooBody.swf", "orders"=>"", "tags"=>"",
      #           "id"=>"30019448", "color1"=>"", "customData"=>"", "lastUpdated"=>"1241111552", "doCallback"=>"0",
      #           "thumbUrl"=>"http://assets.bunchball.com/catalog/TofooBody.swf", "canUnselect"=>"false",
      #           "color2"=>"", "catalogName"=>"DEFAULT_AVATAR", "maxOwnedCountPerUser"=>"-1", "description"=>"",
      #           "realItem"=>"0", "catalogItemId"=>"30019448", "pointCategoryId"=>"283426"
      #         }
      #       ]
      #     },
      #     "recordId" => "AvatarModule.willy@wonka.net",
      #     "instanceName"=>"foo",
      #     "type"=>"AvatarModule",
      #     "skinColor"=>""
      #   },
      #   "method"=>"user.createAvatar",
      #   "server"=>"sb00.prod.bunchball.net/nitro4.2.0",
      #   "asyncToken"=>"9-255-253-259-255-253-259-255-253"
      # }
      # }

      def self.create_avatar(user_id, catalog, instance, params = {})
        response = post("user.createAvatar", {:userId => user_id, :catalogName => catalog, :instanceName => instance}.merge(params))
        Response.new(response, 'AvatarRecord')
      end

      def create_avatar(catalog, instance, params = {})
        User.create_avatar(@user_id, catalog, instance, session.merge(params))
      end

      # Return values here are not documented in the Wiki, so here they are for now:
      #
      # { "Nitro" =>
      #   { "res" => "ok",
      #     "CanvasRecord" =>
      #     { "recordId" => "CanvasModule.willy@wonka.net",
      #       "instanceName"=>"foo_canvas",
      #       "canvasItems"=>true
      #     },
      #     "method" => "user.createCanvas",
      #     "server" => "sb00.prod.bunchball.net/nitro4.2.0",
      #     "asyncToken"=>"4-134-139-134-134-139-134-134-139"
      #   }
      # }
      def self.create_canvas(user_id, catalog, instance, params = {})
        response = post("user.createCanvas", {:userId => user_id, :catalogName => catalog, :instanceName => instance}.merge(params))
        Response.new(response, 'CanvasRecord')
      end

      def create_canvas(catalog, instance, params = {})
        User.create_canvas(@user_id, catalog, instance, session.merge(params))
      end

      def self.create_competition(user_ids, comp_name, params = {})
        response = post("user.createCompetition", {:competitionName => comp_name, :userIds => user_ids}.merge(params))
        Response.new(response, 'competitions')
      end

      # Note sure how useful an instance version of this one will be, but still...
      def create_competition(comp_name, params = {})
        User.create_competition(@user_id, comp_name, session.merge(params))
      end

      def self.credit_points(user_id, points, params = {})
        response = post("user.creditPoints", {:userId => user_id, :points => points.to_i}.merge(params))
        Response.new(response, 'User')
      end

      def credit_points(points, params = {})
        response = User.credit_points(@user_id, points, session.merge(params))
      end

      def self.debit_points(user_id, points, params = {})
        response = post("user.debitPoints", {:userId => user_id, :points => points.to_i}.merge(params))
        Response.new(response, 'User')
      end

      def debit_points(points, params = {})
        response = User.debit_points(@user_id, points, session.merge(params))
      end

      def self.delete_comment(sender, recipient, comment_id, params = {})
        response = post("user.deleteComment", {:sender => sender, :recipient => recipient, :commentId => comment_id}.merge(params))
        Response.new(response)
      end

      def delete_comment(recipient, comment_id, params = {})
        User.delete_comment(@user_id, recipient, comment_id, session.merge(params))
      end

      def self.exists(user_id, params = {})
        params[:storeResponse] = params[:storeResponse].to_s if params[:storeResponse]
        response = post("user.exists", {:userId => user_id}.merge(params))
        response = Response.new response
        response.payload = (response.nitro['Exists'] == "true")
        response
      end

      def exists(user_id, params = {})
        User.exists(user_id, session.merge(params))
      end

      def self.get_action_history(user_id, params = {})
        response = post("user.getActionHistory", {:userId => user_id}.merge(params))
        response = Response.new response

        # While we figure out what all getActionHistory *might* return, let's just leave a little alert here
        raise if response.nitro['ActionHistoryRecord'].keys.size > 1

        # I think this API call may return multiple ActionHistoryItem arrays,
        # but I'm not certain. So for now, just return the one.
        response.payload = response.nitro['ActionHistoryRecord']['ActionHistoryItem']
        response
      end

      # For instance method, just add @user_id and pass it up to the class method.
      def get_action_history(params = {})
        User.get_action_history(@user_id, session.merge(params))
      end

      def self.get_action_target_value(user_id, tag, target, params = {})
        # Let post add the required sessionKey
        response = post("user.getActionTargetValue", {:userId => user_id, :tag => tag, :target => target})
        Response.new(response, 'targetValue')
      end

      # For instance method, just add @user_id and pass it up to the class method.
      def get_action_target_value(tag, target, params = {})
        User.get_action_target_value(@user_id, tag, target, session.merge(params))
      end

      def self.get_avatar_items(user_id, instance_name, params = {})
        response = post("user.getAvatarItems", {:userId => user_id, :instanceName => instance_name}.merge(params))
        Response.new(response, 'AvatarRecord')
      end

      def get_avatar_items(instance_name, params = {})
        User.get_avatar_items(@user_id, instance_name, session.merge(params))
      end

      def self.get_avatars(user_id, params = {})
        response = post("user.getAvatars", {:userId => user_id}.merge(params))
        # valid but no avatars: @parsed_response={"Nitro"=>{"res"=>"ok", "method"=>"user.getAvatars",
        # valid with avatars: @parsed_response={"Nitro"=>{"res"=>"ok", "UserCatalogInstance"=>{"name"=>"foo"}, "method"...
        # invalid (presumably): @parsed_response={"Nitro"=>{"res"=>"err", "something..."}}
        Response.new(response, 'UserCatalogInstance')
      end

      def get_avatars(params = {})
        User.get_avatars(@user_id, session.merge(params))
      end

      def self.get_canvas_items(user_id, instance_name, params = {})
        response = post("user.getCanvasItems", {:userId => user_id, :instanceName => instance_name}.merge(params))
        Response.new(response, 'CanvasRecord')
      end

      def get_canvas_items(instance_name, params = {})
        User.get_canvas_items(@user_id, instance_name, session.merge(params))
      end

      def self.get_canvases(user_id, params = {})
        response = post("user.getCanvases", {:userId => user_id}.merge(params))
        # valid but no canvases: @parsed_response={"Nitro"=>{"res"=>"ok", "method"=>"user.getCanvases",
        # valid with canvases: @parsed_response={"Nitro"=>{"res"=>"ok", "UserCatalogInstance"=>{"name"=>"foo"}, "method"...
        # invalid (presumably): @parsed_response={"Nitro"=>{"res"=>"err", "something..."}}
        Response.new(response, 'UserCatalogInstance')
      end

      def get_canvases(params = {})
        User.get_canvases(@user_id, session.merge(params))
      end

      def self.get_challenge_progress(user_id, params = {})
        response = post("user.getChallengeProgress", {:userId => user_id}.merge(params))
        response = Response.new(response, 'challenges')
        challenges = []
        [response.payload['Challenge']].flatten.compact.each do |challenge|
          challenges << Challenge.new(challenge)
        end
        response.payload = challenges
        response
      end

      def get_challenge_progress(params = {})
        User.get_challenge_progress(@user_id, session.merge(params))
      end

      def self.get_comments(user_id, params = {})
        response = post("user.getComments", {:userId => user_id}.merge(params))
        Response.new(response, 'UserComments')
      end

      def get_comments(params = {})
        User.get_comments(@user_id, session.merge(params))
      end

      def self.get_competition_progress(user_id, params = {})
        response = post("user.getCompetitionProgress", {:userId => user_id}.merge(params))
        Response.new(response, 'competitions')
      end

      def get_competition_progress(params = {})
        User.get_competition_progress(@user_id, session.merge(params))
      end

      def self.get_custom_url(user_id, tag, landing_url, params = {})
        response = post("user.getCustomUrl", {:userId => user_id, :tag => tag, :landingUrl => landing_url}.merge(params))
        Response.new response
      end

      def get_custom_url(tag, landing_url, params = {})
        User.get_custom_url(@user_id, tag, landing_url, session.merge(params))
      end

      def self.get_friends(user_id, friend_type, params = {})
        response = post("user.getFriends", {:userId => user_id, :friendType => friend_type}.merge(params))
        response = Response.new(response)
        if response.nitro['users']
          response.payload = response.nitro['users']['User'] rescue []
        end
        return response
      end

      def get_friends(friend_type, params = {})
        response = User.get_friends(@user_id, friend_type, session.merge(params))
      end

      # This API call does not return what the wiki says it does as of this writing:
      #   http://wiki.bunchball.com/w/page/12748024/user_getGifts
      # There are others that are also fibbed about on the Wiki.
      def self.get_gifts(user_ids, params = {})
        response = post("user.getGifts", {:userIds => user_ids}.merge(params))
        response = Response.new(response)
        response.payload = response.nitro['users']['User']
        return response
      end

      def get_gifts(params = {})
        User.get_gifts(@user_id, session.merge(params))
      end

      def self.get_groups(user_id, params = {})
        response = post("user.getGroups", {:userId => user_id}.merge(params))
        Response.new(response, 'userGroups')
      end

      def get_groups(params = {})
        User.get_groups(@user_id, session.merge(params))
      end

      def self.get_level(user_ids, params = {})
        response = post("user.getLevel", {:userIds => user_ids}.merge(params))
        response = Response.new(response, 'users')
        payload = []
        [response.payload['User']].flatten.compact.each do |user|
          user['level'] = Level.new(user['SiteLevel'])
          payload << user
        end
        response.payload = payload
        response
      end

      def get_level(params = {})
        response = User.get_level(@user_id, session.merge(params))
        response.payload = response.payload.first['level']
        response
      end

      def self.get_next_level(user_id, params = {})
        response = post("user.getNextLevel", {:userId => user_id}.merge(params))
        response = Response.new(response, 'users')
        response.payload = Level.new(response.payload['User']['SiteLevel'])
        response
      end

      def get_next_level(params = {})
        response = User.get_next_level(@user_id, session.merge(params))
      end

      def self.get_next_challenge(user_id, params = {})
        response = post("user.getNextChallenge", {:userId => user_id}.merge(params))
        response = Response.new(response, 'challenges')
        if response.valid?
          response.payload = Challenge.new(response.payload['Challenge'])
        end
        response
      end

      def get_next_challenge(params = {})
        User.get_next_challenge(@user_id, session.merge(params))
      end

      def self.get_owned_items(user_id, params = {})
        response = post("user.getOwnedItems", {:userId => user_id}.merge(params))
        Response.new(response, 'OwnedItemsRecord')
      end

      def get_owned_items(params = {})
        response = User.get_owned_items(@user_id, session.merge(params))
      end

      def self.get_pending_notifications(user_id, params = {})
        response = post("user.getPendingNotifications", {:userId => user_id}.merge(params))
        # Two top-level keys here need returning, so we'll just return the whole thing.
        Response.new response
      end

      def get_pending_notifications(params = {})
        response = User.get_pending_notifications(@user_id, session.merge(params))
      end

      def self.get_points_balance(user_id, params = {})
        response = post("user.getPointsBalance", {:userId => user_id}.merge(params))
        response = Response.new(response)
        response.payload = response.nitro['Balance']
        response
      end

      def get_points_balance(params = {})
        response = User.get_points_balance(@user_id, session.merge(params))
      end

      def self.get_points_history(user_id, params = {})
        response = post("user.getPointsHistory", {:userId => user_id}.merge(params))
        Response.new(response, 'PointsHistoryRecord')
      end

      def get_points_history(params = {})
        response = User.get_points_history(@user_id, session.merge(params))
      end

      def self.get_preference(user_id, name, params = {})
        response = post("user.getPreference", {:userId => user_id, :name => name}.merge(params))
        Response.new(response, 'userPreferences')
      end

      def get_preference(name, params = {})
        response = User.get_preference(@user_id, name, session.merge(params))
      end

      def self.get_preferences(user_id, names, params = {})
        response = post("user.getPreferences", {:userId => user_id, :names => names}.merge(params))
        Response.new(response, 'userPreferences')
      end

      def get_preferences(names, params = {})
        response = User.get_preferences(@user_id, names, session.merge(params))
      end

      def self.get_responses(user_id, params = {})
        response = post("user.getResponses", {:userId => user_id}.merge(params))
        Response.new(response, 'responses')
      end

      def get_responses(params = {})
        User.get_responses(@user_id, session.merge(params))
      end

      def self.get_social_status(user_id, params = {})
        response = post("user.getSocialStatus", {:userId => user_id}.merge(params))
        Response.new response
      end

      def get_social_status(params = {})
        User.get_social_status(@user_id, session.merge(params))
      end

      def self.gift_item(user_id, recipient_id, item_id, params = {})
        response = post("user.giftItem", {:userId => user_id, :recipientId => recipient_id, :itemId => item_id}.merge(params))
        Response.new response
      end

      def gift_item(recipient_id, item_id, params = {})
        response = User.gift_item(@user_id, recipient_id, item_id, session.merge(params))
      end

      def self.invite_friend(user_id, friend_id, params = {})
        response = post("user.inviteFriend", {:userId => user_id, :friendId => friend_id}.merge(params))
        Response.new response
      end

      def invite_friend(friend_id, params = {})
        response = User.invite_friend(@user_id, friend_id, session.merge(params))
      end

      # Wiki docs don't say on this method either that userId is required,
      # or what happens if it is left out. Typically, in methods like this,
      # if the user_id isn't specified, it defaults to the currently
      # logged-in user, which makes sense, so I'm going to treat it like that.
      def self.join_group(user_id, group_name, params = {})
        response = post("user.joinGroup", {:userId => user_id, :groupName => group_name}.merge(params))
        Response.new(response, 'userGroups')
      end

      def join_group(group_name, params = {})
        User.join_group(@user_id, group_name, session.merge(params))
      end

      def self.leave_all_groups(user_id, params = {})
        response = post("user.leaveAllGroups", {:userId => user_id}.merge(params))
        Response.new(response, 'userGroups')
      end

      def leave_all_groups(params = {})
        User.leave_all_groups(@user_id, session.merge(params))
      end

      def self.leave_group(user_id, group_name, params = {})
        response = post("user.leaveGroup", {:userId => user_id, :groupName => group_name}.merge(params))
        Response.new(response, 'userGroups')
      end

      def leave_group(group_name, params = {})
        User.leave_group(@user_id, group_name, session.merge(params))
      end

      def self.log_action(user_id, tags, params = {})
        params[:storeResponse] = params[:storeResponse].to_s if params[:storeResponse]

        response = post("user.logAction", {:tags => tags, :userId => user_id}.merge(params))
        Response.new response
      end

      def log_action(tags, params = {})
        User.log_action(@user_id, tags, session.merge(params))
      end

      # From the Wiki: "This method is identical to user.logAction in all ways
      # except it can ONLY log actions for tags with low-security enabled."
      # So we will just pass it to log_action and let the API handle security.
      # We are, after all, a very thin wrapper.
      def client_log_action(tags, params = {})
        log_action(tags, params)
      end

      def self.modify_user_id(old_user_id, new_user_id, params = {})
        response = post("user.modifyUserId", {:oldUserId => old_user_id, :newUserId => new_user_id}.merge(params))
        Response.new response
      end

      def modify_user_id(new_user_id, params = {})
        User.modify_user_id(@user_id, new_user_id, session.merge(params))
      end

      # Wiki for [place|remove]AvatarItem is ambiguous about whether instanceName is
      # required for place. Wiki doesn't say it's required for placeAvatarItem, and
      # the sample request doesn't show that it is.  However, it DOES say that it's
      # required for removeAvatarItem, yet the sample request there doesn't specify
      # an instanceName, either.  It seems highly unlikely that placeAvatarItem and
      # removeAvatarItem would have *different* criteria for whether the instanceName
      # is required. I just don't know which of the two to believe, whether it's
      # required or not. And at the moment, I don't have the information to create an
      # avatar item and check whether place/remove work with/without an instanceName.
      # So for now we're treating it as if it's NOT required. (TODO)
      def self.place_avatar_item(user_id, item_id, params = {})
        response = post("user.placeAvatarItem", {:userId => user_id, :itemId => item_id}.merge(params))
        Response.new(response, 'AvatarRecord')
      end

      def place_avatar_item(item_id, params = {})
        User.place_avatar_item(@user_id, item_id, session.merge(params))
      end

      def self.place_canvas_item(user_id, instance, x, y, z_order, params = {})
        response = post("user.placeCanvasItem", {:userId => user_id, :instanceName => instance, :x => x, :y => y, :zOrder => z_order}.merge(params))
        Response.new(response, 'CanvasRecord')
      end

      # TODO : Need to test this against a real canvas and make sure that the return values are correct
      def place_canvas_item(instance, x, y, z_order, params = {})
        User.place_canvas_item(@user_id, instance, x, y, z_order, session.merge(params))
      end

      def self.purchase_item(user_id, item_id, params = {})
        response = post("user.purchaseItem", {:userId => user_id, :itemId => item_id}.merge(params))
        Response.new response
      end

      def purchase_item(item_id, params = {})
        response = User.purchase_item(@user_id, item_id, session.merge(params))
      end

      def self.remove_avatar_item(user_id, item_id, params = {})
        response = post("user.removeAvatarItem", {:userId => user_id, :itemId => item_id}.merge(params))
        Response.new(response, 'AvatarRecord')
      end

      def remove_avatar_item(item_id, params = {})
        User.remove_avatar_item(@user_id, item_id, session.merge(params))
      end

      def self.remove_canvas_item(user_id, item_id, instance, params = {})
        response = post("user.removeCanvasItem", {:userId => user_id, :instanceName => instance, :canvasItemId => item_id}.merge(params))
        Response.new(response, 'CanvasRecord')
      end

      def remove_canvas_item(item_id, instance, params = {})
        User.remove_canvas_item(@user_id, item_id, instance, session.merge(params))
      end

      # Wiki is incorrect about the return value of this API call as well. When
      # successful, it returns something like this:
      #
      # {"Nitro" => { "res" => "ok", "method" => "user.removeFriend", "server"=>"...", "asyncToken"=>"..."}}
      #
      # Curiously, it returns pretty much the exact same thing if you attempt to
      # remove a "friend" that doesn't exist, or is not in a friend state with user_id.
      def self.remove_friend(user_id, friend_id, params = {})
        response = post("user.removeFriend", {:userId => user_id, :friendId => friend_id}.merge(params))
        Response.new(response)
      end

      def remove_friend(friend_id, params = {})
        response = User.remove_friend(@user_id, friend_id, session.merge(params))
      end

      def self.remove_preference(user_id, name, params = {})
        response = post("user.removePreference", {:userId => user_id, :name => name}.merge(params))
        Response.new(response, 'userPreferences')
      end

      def remove_preference(name, params = {})
        response = User.remove_preference(@user_id, name, session.merge(params))
      end

      def self.reset_level(user_id, params = {})
        response = post("user.resetLevel", {:userId => user_id}.merge(params))
        Response.new(response, 'users')
      end

      def reset_level(params = {})
        response = User.reset_level(@user_id, session.merge(params))
      end

      def self.save_comment(user_id, recipient_id, value, params = {})
        response = post("user.saveComment", {:userId => user_id, :recipientId => recipient_id, :value => value}.merge(params))
        Response.new response
      end

      def save_comment(recipient_id, value, params = {})
        User.save_comment(@user_id, recipient_id, value, session.merge(params))
      end

      # This one requires either itemId or ownedItemId (but not both, presumably)
      # be specified, so we have to leave that in params, rather than using a
      # positional param for the required items.
      def self.sellback_item(user_id, params = {})
        response = post("user.sellbackItem", {:userId => user_id}.merge(params))
        Response.new response
      end

      def sellback_item(params = {})
        response = User.sellback_item(@user_id, session.merge(params))
      end

      def self.set_avatar_color(user_id, instance, color, params = {})
        response = post("user.setAvatarColor", {:userId => user_id, :instanceName => instance, :skinColor => color}.merge(params))
        Response.new(response, 'AvatarRecord')
      end

      def set_avatar_color(instance, color, params = {})
        User.set_avatar_color(@user_id, instance, color, session.merge(params))
      end

      def self.set_level(user_id, level_name, params = {})
        response = post("user.setLevel", {:userId => user_id, :levelName => level_name}.merge(params))
        Response.new(response, 'users')
      end

      def set_level(level_name, params = {})
        response = User.set_level(@user_id, level_name, session.merge(params))
      end

      def self.set_preference(user_id, name, params = {})
        response = post("user.setPreference", {:userId => user_id, :name => name}.merge(params))
        Response.new(response, 'userPreferences')
      end

      def set_preference(name, params = {})
        response = User.set_preference(@user_id, name, session.merge(params))
      end

      def self.set_preferences(user_id, names, params = {})
        response = post("user.setPreferences", {:userId => user_id, :names => names}.merge(params))
        Response.new(response, 'userPreferences')
      end

      def set_preferences(names, params = {})
        response = User.set_preferences(@user_id, names, session.merge(params))
      end

      # This very strangely-named method doesn't actually set a social 'status' (in the way
      # the various social networks use it), but rather sets the social network connection
      # credentials to allow the app to interact with the given user's social apps.  Also,
      # the documentation only shows/documents Facebook keys, though the sample request shows
      # Twitter return values, and the social API methods generally act as though they will
      # handle Twitter as well.
      #
      # TODO : determine whether the API allows undocumented Twitter keys in this method, or
      # some other way to establish Twitter credentials in the app.
      def self.set_social_status(user_id, facebook_id, params = {})
        response = post("user.setSocialStatus", {:userId => user_id, :facebookId => facebook_id}.merge(params))
        Response.new response
      end

      def set_social_status(facebook_id, params = {})
        User.set_social_status(@user_id, facebook_id, session.merge(params))
      end

      def self.social_link_perform_connector_action(user_id, action, account, params = {})
        response = post("user.socialLinkPerformConnectorAction", {:userId => user_id, :action => action, :account => account}.merge(params))
        Response.new response
      end

      def social_link_perform_connector_action(action, account, params = {})
        User.social_link_perform_connector_action(@user_id, action, account, session.merge(params))
      end

      def self.store_notifications(user_ids, notification_names, params = {})
        response = post("user.storeNotifications", {:userIds => user_ids, :notificationNames => notification_names}.merge(params))
        Response.new response
      end

      def store_notifications(notification_names, params = {})
        response = User.store_notifications(@user_id, notification_names, session.merge(params))
      end

      def self.transfer_points(src_user_id, dest_user_id, params = {})
        params[:storeResponse] = params[:storeResponse].to_s if params[:storeResponse]
        response = post("user.transferPoints", {:srcUserId => src_user_id, :destUserId => dest_user_id}.merge(params))
        Response.new response
      end

      def transfer_points(dest_user_id, params = {})
        User.transfer_points(@user_id, dest_user_id, session.merge(params))
      end
      # This really should be the name of the instance method version of this
      alias transfer_points_to_user transfer_points

    end
  end
end
