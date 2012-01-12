require 'test_helper'

class TestAdmin < Test::Unit::TestCase
  def teardown
    Bunchball::Nitro.logout
  end

  def base_keys
    {:sessionKey => '1234'}
  end

  def test_create_action_tag
    params = {:name => 'twinkle'}

    return_value = {'Nitro' => {'res' => 'ok', 'tags' =>
                                 { 'Tag' => 'foo' }
                               }
                   }

    Bunchball::Nitro::Admin.expects(:post).with('admin.createActionTag', params).returns(return_value)

    response = Bunchball::Nitro::Admin.create_action_tag('twinkle')
    assert_equal response.payload['Tag'], 'foo'
  end

  def test_create_challenge
    params = {:name => 'twinkle', :pointAward => 80, :activeFlag => 1}

    return_value = {'Nitro' => {'res' => 'ok', 'challenges' =>
        {'Challenge' =>
          { 'groupFlag' => '0', 'name' => 'twinkle', 'groupPointAward' => '0', 'activeFlag' => '1',
            'pointAward' => '80', 'rules' => true, 'order' => '0', 'id' => '3988448', 'ruleMatchType' => '0',
            'dateIssued' => '1325219909', 'tags' => '', 'dailyAchievementLimit' => '0', 'callbackFlag' => '0',
            'startTime' => '1325219909', 'endTime' => '0', 'serviceType' => '1', 'pointCategoryId' => '283426',
            'applyMultiplier' => '0', 'repeatable' => '0', 'hideUntilEarned' => '0'
          }
        }
      }
    }

    Bunchball::Nitro::Admin.expects(:post).with('admin.createChallenge', params).returns(return_value)

    response = Bunchball::Nitro::Admin.create_challenge('twinkle', :pointAward => 80, :activeFlag => 1)
    assert_equal 'twinkle', response.payload['Challenge']['name']
    assert_equal '80', response.payload['Challenge']['pointAward']
  end

  def test_create_rule
    params = {:type => 'timeRange'}

    return_value = {'Nitro' => {'res' => 'ok', 'challenges' =>
        { 'Challenge' => 'foo' }
      }
    }

    Bunchball::Nitro::Admin.expects(:post).with('admin.createRule', params).returns(return_value)

    response = Bunchball::Nitro::Admin.create_rule('timeRange')
    assert_equal response.payload['Challenge'], 'foo'
  end

  def test_create_rule_with_invalid_type
    response = Bunchball::Nitro::Admin.create_rule('bloglypoo')
    assert_equal response, nil
  end

  def test_delete_action_tag
    params = {:tagId => '12345678'}

    return_value = { 'Nitro' => { 'res' => 'ok', 'method' => 'admin.deleteActionTag',
                                  'DeleteSuccess' => { 'id' => '12345678' }
                                }
                   }

    Bunchball::Nitro::Admin.expects(:post).with('admin.deleteActionTag', params).returns(return_value)

    response = Bunchball::Nitro::Admin.delete_action_tag('12345678')
    assert_equal response.payload, '12345678'
  end

  def test_get_action_tags
    params = {}

    return_value = {'Nitro' => {'res' => 'ok', 'tags' =>
        { 'Tag' => 'foo' }
      }
    }

    Bunchball::Nitro::Admin.expects(:post).with('admin.getActionTags', params).returns(return_value)

    response = Bunchball::Nitro::Admin.get_action_tags
    assert_equal response.payload, 'foo'
  end

  def test_get_challenges
    params = {}

    return_value = {'Nitro' => {'res' => 'ok', 'challenges' =>
        {'Challenge' => {'name' => 'A challenge', 'rules' => {'Rule' => 'foo' } }}
      }
    }

    Bunchball::Nitro::Admin.expects(:post).with('admin.getChallenges', params).returns(return_value)

    response = Bunchball::Nitro::Admin.get_challenges
    assert response.payload.first.is_a? Bunchball::Nitro::Challenge
    assert_equal response.payload.first.rules, ['foo']
  end

  def test_get_complete_user_record
    params = {:userId => "a_user"}

    return_value = { 'Nitro' => { 'res' => 'ok',
                                  'User' => {
                                    'adminType' => '0',
                                    'id'        => '3657016176',
                                    'userId'    => 'a_user'
                                  }
                                }
                   }

    Bunchball::Nitro::Admin.expects(:post).with("admin.getCompleteUserRecord", params).returns(return_value)

    response = Bunchball::Nitro::Admin.get_complete_user_record('a_user')
    assert_equal response.payload['userId'], 'a_user'
  end

  def test_login_admin
    body_params = {:method => 'admin.loginAdmin', :userId => 'winnerwinner@chickendinner.com',
                   :password => 'password', :apiKey => "1234"}
    return_value = {'Nitro' => {'Login' => {'sessionKey' => 'winning'}}}

    HTTParty.expects(:post).with(api_url, :body => body_params).returns(return_value)

    response = Bunchball::Nitro.login_admin('winnerwinner@chickendinner.com', 'password', '1234')
    assert_equal 'winning', response
  end

  def test_update_action_tag
    params = {:tagId => 'a_tag'}

    return_value = { 'Nitro' => { 'res' => 'ok',
                                  "tags" =>
                                  { "Tag" =>
                                    { "name" => "a_tag", "category" => "0", "isActionTag" => "1", "rateLimit" => "3",
                                      "id" => "2297149096", "isEditable" => "1", "serviceActionType" => "1",
                                      "clientId" => "144464|-563|8952078810395989", "serviceType" => "1",
                                      "lowSecurity" => "1", "prefixMatch" => "0"
                                    }
                                  },
                                }
                   }

    Bunchball::Nitro::Admin.expects(:post).with("admin.updateActionTag", params).returns(return_value)

    response = Bunchball::Nitro::Admin.update_action_tag('a_tag')
    assert_equal response.payload['name'], 'a_tag'
  end

end
