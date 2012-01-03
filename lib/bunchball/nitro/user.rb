module Bunchball
  module Nitro
    class User < ApiBase
      def initialize(user_id)
        @user_id = user_id
        @session_key = Bunchball::Nitro.authenticate(user_id)
      end

      def session
        {:sessionKey => @session_key}
      end

      def self.award_challenge(user_id, challenge, params = {})
        response = post("user.awardChallenge", {:userId => user_id, :challenge => challenge}.merge(params))
        return response['Nitro']['Achievements']
      end

      def award_challenge(challenge, params = {})
        User.award_challenge(@user_id, challenge, params)
      end

      def self.create_competition(user_ids, comp_name, params = {})
        response = post("user.createCompetition", {:competitionName => comp_name, :userIds => user_id}.merge(params))
        return response['Nitro']['competitions']
      end

      def create_competition(comp_name, params = {})
        User.create_competition(@user_id, params)
      end

      def self.credit_points(user_id, points, params = {})
        response = post("user.creditPoints", {:userId => user_id, :points => points.to_i}.merge(params))
        return response['Nitro']['User']
      end

      def credit_points(points, params = {})
        response = User.credit_points(@user_id, points, params)
      end

      def self.debit_points(user_id, points, params = {})
        response = post("user.debitPoints", {:userId => user_id, :points => points.to_i}.merge(params))
        return response['Nitro']['User']
      end

      def debit_points(points, params = {})
        response = User.debit_points(@user_id, points, params)
      end

      def self.exists(user_id, params = {})
        params[:storeResponse] = params[:storeResponse].to_s if params[:storeResponse]
        response = post("user.exists", {:userId => user_id}.merge(params))
        return response["Nitro"]["Exists"] == "true"
      end

      def self.get_action_history(user_id, params = {})
        response = post("user.getActionHistory", {:userId => user_id}.merge(params))
        # While we figure out what all getActionHistory *might* return, let's just leave a little alert here
        raise unless response['Nitro']['ActionHistoryRecord'].keys.size < 2
        # I think this API call may return multiple result arrays, but I'm
        # not certain. So for now, just return the one.
        return response['Nitro']['ActionHistoryRecord']['ActionHistoryItem']
      end

      # For instance method, just add @user_id and pass it up to the class method.
      def get_action_history(params = {})
        User.get_action_history(@user_id ,params)
      end

      def self.get_action_target_value(user_id, tag, target)
        # Let post add the required sessionKey
        response = post("user.getActionTargetValue", {:userId => user_id, :tag => tag, :target => target})
        return response['Nitro']['targetValue']
      end

      # For instance method, just add @user_id and pass it up to the class method.
      def get_action_target_value(tag, target)
        User.get_action_target_value(@user_id, tag, target)
      end

      def self.get_challenge_progress(user_id, params = {})
        response = post("user.getChallengeProgress", {:userId => user_id}.merge(params))
        return response['Nitro']['challenges']
      end

      def get_challenge_progress(params = {})
        User.get_challenge_progress(@user_id, params)
      end

      def self.get_competition_progress(user_id, params = {})
        response = post("user.getCompetitionProgress", {:userId => user_id}.merge(params))
        return response['Nitro']['competitions']
      end

      def get_competition_progress(params = {})
        User.get_competition_progress(@user_id, params)
      end

      # This API call does not return what the wiki says it does as of this writing:
      #   http://wiki.bunchball.com/w/page/12748024/user_getGifts
      # There are others that are also fibbed about on the Wiki.
      def self.get_gifts(user_ids, params = {})
        response = post("user.getGifts", {:userIds => user_ids}.merge(params))
        return response['Nitro']['users']['User']
      end

      def get_gifts(params = {})
        response = User.get_gifts(@user_id, session.merge(params))
      end

      def self.get_groups(user_id, params = {})
        response = post("user.getGroups", {:userId => user_id}.merge(params))
        return response['Nitro']['userGroups']
      end

      def get_groups(params = {})
        User.get_groups(@user_id, params)
      end

      def self.get_next_challenge(user_id, params = {})
        response = post("user.getNextChallenge", {:userId => user_id}.merge(params))
        return response['Nitro']['challenges']
      end

      def get_next_challenge(params = {})
        User.get_next_challenge(@user_id, params)
      end

      def self.get_points_balance(user_id, params = {})
        response = post("user.getPointsBalance", {:userId => user_id}.merge(params))
        return response['Nitro']['Balance']
      end

      def get_points_balance(params = {})
        response = User.get_points_balance(@user_id, session.merge(params))
      end

      def self.get_points_history(user_id, params = {})
        response = post("user.getPointsHistory", {:userId => user_id}.merge(params))
        return response['Nitro']['PointsHistoryRecord']
      end

      def get_points_history(params = {})
        response = User.get_points_history(@user_id, params)
      end

      def self.get_responses(user_id)
        response = post("user.getResponses", :userId => user_id)
        return response['Nitro']['responses']
      end

      def get_responses
        User.get_responses(@user_id)
      end

      # Wiki docs don't say on this method either that userId is required,
      # or what happens if it is left out. Typically, in methods like this,
      # if the user_id isn't specified, it defaults to the currently
      # logged-in user, which makes sense, so I'm going to treat it like that.
      def self.join_group(user_id, group_name, params = {})
        response = post("user.joinGroup", {:userId => user_id, :groupName => group_name}.merge(params))
        return response['Nitro']['userGroups']
      end

      def join_group(group_name, params = {})
        User.join_group(@user_id, group_name, session.merge(params))
      end

      def self.leave_all_groups(user_id, params = {})
        response = post("user.leaveAllGroups", {:userId => user_id}.merge(params))
        return response['Nitro']['userGroups']
      end

      def leave_all_groups(params = {})
        User.leave_all_groups(@user_id, session.merge(params))
      end

      def self.leave_group(user_id, group_name, params = {})
        response = post("user.leaveGroup", {:userId => user_id, :groupName => group_name}.merge(params))
        return response['Nitro']['userGroups']
      end

      def leave_group(group_name, params = {})
        User.leave_group(@user_id, group_name, session.merge(params))
      end

      def self.log_action(user_id, tags, params = {})
        params[:storeResponse] = params[:storeResponse].to_s if params[:storeResponse]

        post("user.logAction", {:tags => tags, :userId => user_id}.merge(params))
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
        return response["Nitro"]["res"] == "ok"
      end

      def modify_user_id(new_user_id, params = {})
        User.modify_user_id(@user_id, new_user_id, session.merge(params))
      end

      def self.transfer_points(src_user_id, dest_user_id, params = {})
        params[:storeResponse] = params[:storeResponse].to_s if params[:storeResponse]
        response = post("user.transferPoints", {:srcUserId => src_user_id, :destUserId => dest_user_id}.merge(params))
        return response["Nitro"]["res"] == "ok"
      end

      def transfer_points(dest_user_id, params = {})
        User.transfer_points(@user_id, dest_user_id, session.merge(params))
      end
      # This really should be the name of the instance method version of this
      alias transfer_points_to_user transfer_points

    end
  end
end
