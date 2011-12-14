module Bunchball
  module Nitro
    class User 
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
    end
  end
end