module Bunchball
  module Nitro
    class Admin < ApiBase

      def self.create_action_tag(name, params = {})
        response = post("admin.createActionTag", params.merge(:name => name))
      end

      def self.create_challenge(name, params = {})
        response = post("admin.createChallenge", self.session.merge({:name => name}).merge(params))
        return response['Nitro']['challenges']
      end

      def self.get_action_tags(params = {})
        response = post("admin.getActionTags", params)
        return response['Nitro']['tags']['Tag']
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
