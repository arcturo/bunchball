module Bunchball
  module Nitro
    class Admin < ApiBase
      # From http://wiki.bunchball.com/w/page/39318892/admin_createRule, 'type' param
      RULE_TYPES = %W(sum count value none timeRange withinFolder)

      def self.create_action_tag(name, params = {})
        response = post("admin.createActionTag", {:name => name}.merge(params))
        return response['Nitro']['tags'] || response['Nitro']['Error']
      end

      def self.create_challenge(name, params = {})
        response = post("admin.createChallenge", {:name => name}.merge(params))
        return response['Nitro']['challenges'] || response['Nitro']['Error']
      end

      def self.create_rule(rule_type, params = {})
        return nil unless RULE_TYPES.include? rule_type
        response = post("admin.createRule", {:type => rule_type}.merge(params))
        return response['Nitro']['challenges'] || response['Nitro']['Error']
      end

      # This one is a bit tricky, as HTTParty parses up the XML returned from
      # every HTTP request, and doesn't make available the raw XML. So we get
      # back, not an XML file, but a Ruby object parsed from it.  Perhaps later
      # we should either monkey-path HTTParty or try to reconstruct the XML from
      # the object.
      def self.export_locale_translations(locale, params = {})
        response = post("admin.exportLocaleTranslations", {:locale => locale}.merge(params))
        if (response['Nitro']['res'] == 'ok')
          return response.body
        else
          return nil
        end
      end

      def self.get_action_tags(params = {})
        response = post("admin.getActionTags", params)
        if (response['Nitro']['res'] == 'ok') && response['Nitro']['tags']
          return response['Nitro']['tags']['Tag']
        else
          return nil
        end
      end

      def self.get_challenges(params = {})
        response = post("admin.getChallenges", params)
        return response['Nitro']['challenges'] || response['Nitro']['Error']
      end

      # See comments for the sister method export_locale_translations. This
      # may not work as expected; in particular, it probably won't return a
      # useful object.
      def self.import_locale_translations(locale, data, params = {})
        response = post("admin.exportLocaleTranslations", {:locale => locale, :data => data}.merge(params))
        if (response['Nitro']['res'] == 'ok')
          return response.body
        else
          return nil
        end
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
        p response
        if (response['Nitro']['res'] == 'ok') && response['Nitro']['tags']
          return response['Nitro']['tags']['Tag']
        else
          return nil
        end
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
        p response
        if (response['Nitro']['res'] == 'ok') && response['Nitro']['DeleteSuccess']
          return response['Nitro']['DeleteSuccess']['id']
        else
          return nil
        end
      end
    end
  end
end
