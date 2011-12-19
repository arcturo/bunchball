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

      def self.get_responses(user_id)
        response = post("user.getResponses", :userId => user_id)
        return response['Nitro']['responses']
      end
    end
  end
end