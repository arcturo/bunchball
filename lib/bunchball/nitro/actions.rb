module Bunchball
  module Nitro
    class Actions < ApiBase
      CATEGORIES = [:unknown, :consume_content, :create_content, :information_sharing, :membership_activity]

      def self.create(name, params = {})
        params[:category] = Actions::CATEGORIES.index(params[:category]) if params[:category]
        params[:prefixMatch] = params[:prefixMatch] ? 1 : 0
        params[:lowSecurity] = params[:prefixMatch] ? 1 : 0

        post("admin.createActionTag", params.merge(:name => name))
      end

      def self.all
        post("admin.getActionTags")
      end

      # Log for currently logged in user
      def self.log(tags, params)
        params[:storeResponse] = params[:storeResponse].to_s if params[:storeResponse]

        post("user.logAction", params.merge(:tags => tags))        
      end

      # Log for any user
      def self.log_for_user(user_id, tags, params = {})
        params[:storeResponse] = params[:storeResponse].to_s if params[:storeResponse]

        post("user.logAction", params.merge(:tags => tags, :userId => user_id))
      end

      # Pings the server
      def self.hello
        post("hello")
      end
    end
  end
end