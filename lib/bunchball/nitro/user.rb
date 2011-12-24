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

      def log_action(tags, params = {})
        Actions.log_for_user(@user_id, tags, params.merge(session))
      end

      def self.exists(user_id, params = {})
        params[:storeResponse] = params[:storeResponse].to_s if params[:storeResponse]
        response = post("user.exists", params.merge(:userId => user_id))
        return response["Nitro"]["Exists"] == "true"
      end

      def self.modify_user_id(old_user_id, new_user_id)
        response = post("user.modifyUserId", params.merge(:oldUserId => old_user_id, :newUserId => new_user_id))
        return response["Nitro"]["res"] == "ok"
      end

      def self.transfer_points(src_user_id, dest_user_id)
        params[:storeResponse] = params[:storeResponse].to_s if params[:storeResponse]
        response = post("user.transferPoints", params.merge(:srcUserId => src_user_id, :destUserId => dest_user_id))
        return response["Nitro"]["res"] == "ok"
      end

      def transfer_points_to_user(dest_user_id)
        User.transfer_points(@user_id, dest_user_id)
      end

      def self.get_responses(user_id)
        response = post("user.getResponses", :userId => user_id)
        return response['Nitro']['responses']
      end

      def get_responses
        User.get_responses(@user_id)
      end

      def self.get_action_history(user_id, params = {})
        response = post("user.getActionHistory", params.merge(:userId => user_id))
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
    end
  end
end