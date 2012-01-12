module Bunchball
  module Nitro
    class Admin < ApiBase
      # From http://wiki.bunchball.com/w/page/39318892/admin_createRule, 'type' param
      RULE_TYPES = %W(sum count value none timeRange withinFolder)

      def self.create_action_tag(name, params = {})
        response = post("admin.createActionTag", {:name => name}.merge(params))
        Response.new(response, 'tags')
      end

      def self.create_challenge(name, params = {})
        response = post("admin.createChallenge", {:name => name}.merge(params))
        response = Response.new(response, 'challenges')
        if response.valid?
          response.payload = Challenge.new(response.payload['Challenge'])
        end
        response
      end

      def self.create_rule(rule_type, params = {})
        return nil unless RULE_TYPES.include? rule_type
        response = post("admin.createRule", {:type => rule_type}.merge(params))
        Response.new(response, 'challenges')
      end

      # This method is undocumented in the Bunchball Wiki
      #
      # API returns (on success):
      #
      # {"Nitro" =>
      #   {"res" => "ok", "method"=>"admin.deleteActionTag", "server"=>"sb00.prod.bunchball.net/nitro4.2.0",
      #    "DeleteSuccess" => {"id"=>"2297149096"},
      #    "asyncToken" => "2-182-188-182-182-188-182-182-188"
      #   }
      # }

      def self.delete_action_tag(tag_id, params = {})
        response = post("admin.deleteActionTag", {:tagId => tag_id}.merge(params))
        response = Response.new response
        response.payload = response.valid? ? response.nitro['DeleteSuccess']['id'] : nil
        return response
      end

      # This one is a bit tricky, as HTTParty parses up the XML returned from
      # every HTTP request, and doesn't make available the raw XML. So we get
      # back, not an XML file, but a Ruby object parsed from it.  Perhaps later
      # we should either monkey-path HTTParty or try to reconstruct the XML from
      # the object.
      def self.export_locale_translations(locale, params = {})
        response = post("admin.exportLocaleTranslations", {:locale => locale}.merge(params))
        response = Response.new(response)
        response.payload = response.valid? ? response.body : nil
        return response
      end

      def self.get_action_tags(params = {})
        response = post("admin.getActionTags", params)
        response = Response.new(response)
        if response.valid? && response.nitro['tags']
          response.payload = response.nitro['tags']['Tag']
        else
          response.payload = nil
        end
        return response
      end

      def self.get_challenges(params = {})
        response = post("admin.getChallenges", params)
        response = Response.new(response, 'challenges')
        challenges = []
        [response.payload['Challenge']].compact.each do |challenge|
          challenges << Challenge.new(challenge)
        end
        response.payload = challenges
        response
      end

      # This method is undocumented in the Bunchball Wiki
      #
      # API returns (on success):
      #
      # { "Nitro" =>
      #   { "res" => "ok",
      #     "method" => "admin.getCompleteUserRecord",
      #     "server"=>"sb00.prod.bunchball.net/nitro4.2.0",
      #     "asyncToken"=>"1-109-105-101-109-105-101-109-105"
      #     "User" =>
      #     { "SiteLevel" =>
      #       { "iconUrl" => "http://assets.bunchball.com/widgets/staticimages/poker/levels/09_sharkIcon.png",
      #         "name" => "Shark", "timestamp" => "1326139417", "points" => "900", "type" => "points",
      #         "description" => "Shark"
      #       },
      #       "adminType" => "0", "id" => "3657016176",
      #       "Balance" =>
      #       { "pointCategories" =>
      #         { "PointCategory" =>
      #           { "shortName" => "Pts", "iconUrl" => "", "name" => "Points", "premium" => "0",
      #             "isDefault" => "true", "points" => "1100", "id" => "283426",
      #             "lifetimeBalance" => "1100"
      #           }
      #         },
      #         "points" => "1100", "userId" => "3", "lifetimeBalance" => "1100"
      #       },
      #       "userId" => "3"
      #     }
      #   }
      # }

      def self.get_complete_user_record(user_id, params = {})
        response = post("admin.getCompleteUserRecord", {:userId => user_id}.merge(params))
        Response.new(response, 'User')
      end

      # See comments for the sister method export_locale_translations. This
      # may not work as expected; in particular, it probably won't return a
      # useful object.
      def self.import_locale_translations(locale, data, params = {})
        response = post("admin.exportLocaleTranslations", {:locale => locale, :data => data}.merge(params))
        response = Response.new(response)
        response.payload = response.valid? ? response.body : nil
        return response
      end

      # This method is undocumented in the Bunchball Wiki
      #
      # API returns (on success):
      #
      # {"Nitro" =>
      #   {"res" => "ok", "method" => "admin.updateActionTag", "server" => "sb00.prod.bunchball.net/nitro4.2.0",
      #    "tags" =>
      #    {"Tag" =>
      #      { "name" => "my_tag4", "category" => "0", "isActionTag" => "1", "rateLimit" => "3",
      #        "id" => "2297149096", "isEditable" => "1", "serviceActionType" => "1",
      #        "clientId" => "144464|-563|8952078810395989", "serviceType" => "1", "lowSecurity" => "1", "prefixMatch" => "0"}
      #    },
      #    "asyncToken" => "4-153-157-154-153-157-154-153-157"
      #   }
      # }

      def self.update_action_tag(tag_id, params = {})
        response = post("admin.updateActionTag", {:tagId => tag_id}.merge(params))
        response = Response.new response
        response.payload = response.valid? ? response.nitro['tags']['Tag'] : nil
        return response
      end

    end
  end
end
