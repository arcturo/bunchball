require 'test_helper'

class TestUser < Test::Unit::TestCase
  def teardown
    Bunchball::Nitro.logout
  end

  def setup_user(user_id = 'wibble', return_val = 'a_session_key')
    Bunchball::Nitro.expects(:authenticate).with(user_id).returns(return_val)

    u = Bunchball::Nitro::User.new(user_id)
  end

  def test_initialize
    u = setup_user('wibble', 'winning')

    assert_equal u.session[:sessionKey], 'winning' # heh
  end

  def test_award_challenge
    # Set key instead of mocking login
    Bunchball::Nitro.session_key = "1234"

    params = {:userId => 'wiggly', :challenge => 'A challenge'}

    return_value = {'Nitro' => {'Achievements' => {'challengesAchieved' => {'ChallengeAchieved' =>
        {"name"=>"A challenge", "catalogItems"=>true, "pointCategory"=>"Points", "points"=>"80", "repeatable"=>"0"}
      }}}}

    Bunchball::Nitro::User.expects(:post).with("user.awardChallenge", params).returns(return_value)

    response = Bunchball::Nitro::User.award_challenge('wiggly', 'A challenge')
    assert_equal 'A challenge', response['challengesAchieved']['ChallengeAchieved']['name']
    assert_equal '80', response['challengesAchieved']['ChallengeAchieved']['points']
  end

  def test_award_challenge_instance
    u = setup_user

    Bunchball::Nitro::User.expects(:award_challenge).with(u.user_id, 'A challenge', u.session).returns('foo')

    response = u.award_challenge('A challenge')
    assert_equal response, 'foo'
  end

  def test_create_avatar
    params = {:userId => 'a_user', :catalogName => 'a catalog', :instanceName => 'an instance'}

    return_value = {'Nitro' => {'AvatarRecord' =>
        {'items' => 'foo'}
      }
    }

    Bunchball::Nitro::User.expects(:post).with('user.createAvatar', params).returns(return_value)

    response = Bunchball::Nitro::User.create_avatar('a_user', 'a catalog', 'an instance')
    assert_equal response['items'], 'foo'
  end

  def test_create_avatar_instance
    u = setup_user

    Bunchball::Nitro::User.expects(:create_avatar).with(u.user_id, 'a catalog', 'an instance', u.session).returns('foo')

    response = u.create_avatar('a catalog', 'an instance')
    assert_equal response, 'foo'
  end

  def test_create_competition
    # Set key instead of mocking login
    Bunchball::Nitro.session_key = "1234"

    params = {:competitionName => 'A competition', :userIds => 'user1,user2'}

    return_value = {'Nitro' => {'competitions' =>
        {'Competition' => 'foo'}
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.createCompetition", params).returns(return_value)

    response = Bunchball::Nitro::User.create_competition('user1,user2', 'A competition')
    assert_equal response['Competition'], 'foo'
  end

  def test_create_competition_instance
    u = setup_user

    Bunchball::Nitro::User.expects(:create_competition).with(u.user_id, 'A competition', u.session).returns('foo')

    response = u.create_competition('A competition')
    assert_equal response, 'foo'
  end

  def test_credit_points
    params = {:userId => 'wiggly', :points => 30}

    return_value = {'Nitro' => {'User' => 'foo'}}

    Bunchball::Nitro::User.expects(:post).with("user.creditPoints", params).returns(return_value)

    response = Bunchball::Nitro::User.credit_points('wiggly', 30)
    assert_equal response, 'foo'
  end

  # Test the instance version of the same method
  def test_credit_points_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:credit_points).with(u.user_id, 300, u.session).returns('foo')

    response = u.credit_points(300)
    assert_equal response, 'foo'
  end

  def test_debit_points
    params = {:userId => 'wiggly', :points => 30}

    return_value = {'Nitro' => {'User' => 'foo'}}

    Bunchball::Nitro::User.expects(:post).with("user.debitPoints", params).returns(return_value)

    response = Bunchball::Nitro::User.debit_points('wiggly', 30)
    assert_equal response, 'foo'
  end

  # Test the instance version of the same method
  def test_debit_points_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:debit_points).with(u.user_id, 300, u.session).returns('foo')

    response = u.debit_points(300)
    assert_equal response, 'foo'
  end

  def test_exists
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => {'Exists' => 'true'}}

    Bunchball::Nitro::User.expects(:post).with("user.exists", params).returns(return_value)

    response = Bunchball::Nitro::User.exists('wiggly')
    assert_equal response, true
  end

  def test_exists_instance
    u = setup_user

    Bunchball::Nitro::User.expects(:exists).with('some_user', u.session).returns('foo')

    response = u.exists('some_user')
    assert_equal response, 'foo'
  end

  def test_get_action_history
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => {'res' => 'ok', 'ActionHistoryRecord' =>
        {'ActionHistoryItem' => {'value' => 'foo' }}
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.getActionHistory", params).returns(return_value)

    response = Bunchball::Nitro::User.get_action_history('wiggly')
    assert_equal response['value'], 'foo'
  end

  def test_get_action_history_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_action_history).with('wibble', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_action_history
    assert_equal response, 'foo'
  end

  def test_get_action_target_value
    params = {:userId => 'wiggly', :tag => 'a_tag', :target => 'a_target'}

    return_value = {'Nitro' => {'res' => 'ok', 'targetValue' =>
        {'value' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.getActionTargetValue", params).returns(return_value)

    response = Bunchball::Nitro::User.get_action_target_value('wiggly', 'a_tag', 'a_target')
    assert_equal response['value'], 'foo'
  end

  def test_get_action_target_value_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_action_target_value).with('wibble', 'a_tag', 'a_target', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_action_target_value('a_tag', 'a_target')
    assert_equal response, 'foo'
  end

  def test_get_avatar_items
    params = {:userId => 'a_user', :instanceName => 'an instance'}

    return_value = {'Nitro' => {'AvatarRecord' =>
        {'items' => 'foo'}
      }
    }

    Bunchball::Nitro::User.expects(:post).with('user.getAvatarItems', params).returns(return_value)

    response = Bunchball::Nitro::User.get_avatar_items('a_user', 'an instance')
    assert_equal response['items'], 'foo'
  end

  def test_get_avatar_items_instance
    u = setup_user

    Bunchball::Nitro::User.expects(:get_avatar_items).with(u.user_id, 'an instance', u.session).returns('foo')

    response = u.get_avatar_items('an instance')
    assert_equal response, 'foo'
  end

  def test_get_avatars
    params = {:userId => 'a_user'}

    return_value = {'Nitro' => {'UserCatalogInstance' =>
        {'name' => 'foo'}
      }
    }

    Bunchball::Nitro::User.expects(:post).with('user.getAvatars', params).returns(return_value)

    response = Bunchball::Nitro::User.get_avatars('a_user')
    assert_equal response['name'], 'foo'
  end

  def test_get_avatars_instance
    u = setup_user

    Bunchball::Nitro::User.expects(:get_avatars).with(u.user_id, u.session).returns('foo')

    response = u.get_avatars
    assert_equal response, 'foo'
  end

  def test_get_challenge_progress
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => {'res' => 'ok', 'challenges' =>
        {'Challenge' => {'completionCount' => '1', 'rules' => 'foo' }}
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.getChallengeProgress", params).returns(return_value)

    response = Bunchball::Nitro::User.get_challenge_progress('wiggly')
    assert_equal response['Challenge']['rules'], 'foo'
  end

  def test_get_challenge_progress_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_challenge_progress).with('wibble', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_challenge_progress
    assert_equal response, 'foo'
  end

  def test_get_competition_progress
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => {'res' => 'ok', 'competitions' =>
        {'Competition' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.getCompetitionProgress", params).returns(return_value)

    response = Bunchball::Nitro::User.get_competition_progress('wiggly')
    assert_equal response['Competition'], 'foo'
  end

  def test_get_competition_progress_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_competition_progress).with('wibble', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_competition_progress
    assert_equal response, 'foo'
  end

  def test_get_groups
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => {'res' => 'ok', 'userGroups' =>
        {'Group' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.getGroups", params).returns(return_value)

    response = Bunchball::Nitro::User.get_groups('wiggly')
    assert_equal response['Group'], 'foo'
  end

  def test_get_groups_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_groups).with('wibble', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_groups
    assert_equal response, 'foo'
  end

  def test_get_level
    params = {:userIds => 'wiggly,piggly'}

    return_value = {'Nitro' => {'res' => 'ok', 'users' =>
        {'User' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.getLevel", params).returns(return_value)

    response = Bunchball::Nitro::User.get_level('wiggly,piggly')
    assert_equal response['User'], 'foo'
  end

  def test_get_level_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_level).with('wibble', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_level
    assert_equal response, 'foo'
  end

  def test_get_next_challenge
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => {'res' => 'ok', 'challenges' =>
        {'Challenge' => 'foo'}
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.getNextChallenge", params).returns(return_value)

    response = Bunchball::Nitro::User.get_next_challenge('wiggly')
    assert_equal response['Challenge'], 'foo'
  end

  def test_get_next_challenge_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_next_challenge).with('wibble', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_next_challenge
    assert_equal response, 'foo'
  end

  def test_get_next_level
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => {'res' => 'ok', 'users' =>
        {'User' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.getNextLevel", params).returns(return_value)

    response = Bunchball::Nitro::User.get_next_level('wiggly')
    assert_equal response['User'], 'foo'
  end

  def test_get_next_level_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_next_level).with('wibble', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_next_level
    assert_equal response, 'foo'
  end

  def test_owned_items
    # This one requires one of a pair of item id specifiers be present in params,
    # so we don't use a positional paramater for it. Just pick one for the test.
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => {'res' => 'ok', 'OwnedItemsRecord' =>
        {'ownedItems' => 'foo'}
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.getOwnedItems", params).returns(return_value)

    response = Bunchball::Nitro::User.get_owned_items('wiggly')
    assert_equal response['ownedItems'], 'foo'
  end

  # Test the instance version of the same method
  def test_owned_items_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_owned_items).with(u.user_id, u.session).returns('foo')

    response = u.get_owned_items
    assert_equal response, 'foo'
  end

  def test_get_pending_notifications
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => 'foo' }

    Bunchball::Nitro::User.expects(:post).with("user.getPendingNotifications", params).returns(return_value)

    response = Bunchball::Nitro::User.get_pending_notifications('wiggly')
    assert_equal response, 'foo'
  end

  def test_get_pending_notifications_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_pending_notifications).with('wibble', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_pending_notifications
    assert_equal response, 'foo'
  end

  def test_get_points_balance
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => {'Balance' =>
        {"pointCategories"=>
          {"PointCategory"=>
            {"shortName"=>"Pts",
              "iconUrl"=>"",
             "name"=>"Points",
             "premium"=>"0",
             "isDefault"=>"true",
             "points"=>"877",
             "lifetimeBalance"=>"1002"}},
         "points"=>"877",
         "userId"=>"wiggly",
         "lifetimeBalance"=>"1002"}
       }}

    Bunchball::Nitro::User.expects(:post).with("user.getPointsBalance", params).returns(return_value)

    response = Bunchball::Nitro::User.get_points_balance('wiggly')
    assert_equal response['pointCategories']['PointCategory']['points'], '877'
  end

  # Test the instance version of the same method
  def test_get_points_balance_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_points_balance).with('wibble', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_points_balance
    assert_equal response, 'foo'
  end

  def test_get_points_history
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => {'res' => 'ok', 'PointsHistoryRecord' =>
        {'PointsHistoryItem' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.getPointsHistory", params).returns(return_value)

    response = Bunchball::Nitro::User.get_points_history('wiggly')
    assert_equal response['PointsHistoryItem'], 'foo'
  end

  def test_get_points_history_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_points_history).with('wibble', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_points_history
    assert_equal response, 'foo'
  end

  def test_get_preference
    params = {:userId => 'wiggly', :name => 'preference_name'}

    return_value = {'Nitro' => {'res' => 'ok', 'userPreferences' =>
        {'UserPreference' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.getPreference", params).returns(return_value)

    response = Bunchball::Nitro::User.get_preference('wiggly', 'preference_name')
    assert_equal response['UserPreference'], 'foo'
  end

  def test_get_preference_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_preference).with('wibble', 'preference_name', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_preference('preference_name')
    assert_equal response, 'foo'
  end

  def test_get_preferences
    params = {:userId => 'wiggly', :names => 'preference1|preference2'}

    return_value = {'Nitro' => {'res' => 'ok', 'userPreferences' =>
        {'UserPreference' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.getPreferences", params).returns(return_value)

    response = Bunchball::Nitro::User.get_preferences('wiggly', 'preference1|preference2')
    assert_equal response['UserPreference'], 'foo'
  end

  def test_get_preferences_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_preferences).with('wibble', 'preference1|preference2', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_preferences('preference1|preference2')
    assert_equal response, 'foo'
  end

  def test_get_responses
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => {'res' => 'ok', 'responses' =>
        {'Nitro' => {'Achievements' => 'foo' }}
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.getResponses", params).returns(return_value)

    response = Bunchball::Nitro::User.get_responses('wiggly')
    assert_equal response['Nitro']['Achievements'], 'foo'
  end

  def test_get_responses_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_responses).with('wibble', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_responses
    assert_equal response, 'foo'
  end

  def test_gift_item
    params = {:userId => 'wiggly', :recipientId => 'piggly', :itemId => 'an_item'}

    return_value = {'Nitro' => {'res' => 'ok', 'Balance' => 'foo' } }

    Bunchball::Nitro::User.expects(:post).with("user.giftItem", params).returns(return_value)

    response = Bunchball::Nitro::User.gift_item('wiggly', 'piggly', 'an_item')
    assert_equal response['Balance'], 'foo'
  end

  # Test the instance version of the same method
  def test_gift_item_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:gift_item).with(u.user_id, 'piggly', 'an_item', u.session).returns('foo')

    response = u.gift_item('piggly', 'an_item')
    assert_equal response, 'foo'
  end

  def test_join_group
    params = {:userId => 'wiggly', :groupName => 'a_group'}

    return_value = {'Nitro' => {'res' => 'ok', 'userGroups' =>
        {'Group' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.joinGroup", params).returns(return_value)

    response = Bunchball::Nitro::User.join_group('wiggly', 'a_group')
    assert_equal response['Group'], 'foo'
  end

  def test_join_group_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:join_group).with('wibble', 'a_group', :sessionKey => 'a_session_key').returns('foo')

    response = u.join_group('a_group')
    assert_equal response, 'foo'
  end

  def test_leave_all_groups
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => {'res' => 'ok', 'userGroups' => true } }

    Bunchball::Nitro::User.expects(:post).with("user.leaveAllGroups", params).returns(return_value)

    response = Bunchball::Nitro::User.leave_all_groups('wiggly')
    assert_equal response, true  # want actual true here, not just a value that evals as true
  end

  def test_leave_all_groups_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:leave_all_groups).with('wibble', :sessionKey => 'a_session_key').returns('foo')

    response = u.leave_all_groups
    assert_equal response, 'foo'
  end

  def test_leave_group
    params = {:userId => 'wiggly', :groupName => 'a_group'}

    return_value = {'Nitro' => {'res' => 'ok', 'userGroups' =>
        {'Group' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.leaveGroup", params).returns(return_value)

    response = Bunchball::Nitro::User.leave_group('wiggly', 'a_group')
    assert_equal response['Group'], 'foo'
  end

  def test_leave_group_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:leave_group).with('wibble', 'a_group', :sessionKey => 'a_session_key').returns('foo')

    response = u.leave_group('a_group')
    assert_equal response, 'foo'
  end

  def test_log_action
    params = {:userId => 'wiggly', :tags => 'frog'}

    return_value = { "Nitro" =>
      { "res" => "ok", "method" => "user.logAction" }
    }

    Bunchball::Nitro::User.expects(:post).with("user.logAction", params).returns(return_value)

    response = Bunchball::Nitro::User.log_action('wiggly', 'frog')
    assert_equal response['Nitro']['res'], 'ok'
  end

  def test_log_action_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:log_action).with('wibble', 'frog', :sessionKey => 'a_session_key').returns('foo')

    response = u.log_action('frog')
    assert_equal response, 'foo'
  end

  # We only have an instance version of this method
  def test_client_log_action_instance
    u = setup_user

    # Mock out the instance method
    u.expects(:log_action).with('frog', {}).returns('foo')

    response = u.client_log_action('frog')
    assert_equal response, 'foo'
  end

  def test_modify_user_id
    params = {:oldUserId => 'wiggly', :newUserId => 'puggly'}

    return_value = {'Nitro' => {'res' => 'ok'}}

    Bunchball::Nitro::User.expects(:post).with("user.modifyUserId", params).returns(return_value)

    response = Bunchball::Nitro::User.modify_user_id('wiggly', 'puggly')
    assert_equal response, true  # want actual true here, not just a value that evals as true
  end

  # Test the instance version of the same method
  def test_modify_user_id_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:modify_user_id).with(u.user_id, 'puggly', u.session).returns('foo')

    response = u.modify_user_id('puggly')
    assert_equal response, 'foo'
  end

  def test_place_avatar_item
    params = {:userId => 'a_user', :itemId => 'an item'}

    return_value = {'Nitro' => {'AvatarRecord' =>
        {'items' => 'foo'}
      }
    }

    Bunchball::Nitro::User.expects(:post).with('user.placeAvatarItem', params).returns(return_value)

    response = Bunchball::Nitro::User.place_avatar_item('a_user', 'an item')
    assert_equal response['items'], 'foo'
  end

  def test_place_avatar_item_instance
    u = setup_user

    Bunchball::Nitro::User.expects(:place_avatar_item).with(u.user_id, 'an item', u.session).returns('foo')

    response = u.place_avatar_item('an item')
    assert_equal response, 'foo'
  end

  def test_purchase_item
    params = {:userId => 'wiggly', :itemId => 'an_item'}

    return_value = {'Nitro' => {'res' => 'ok', 'Balance' => 'foo' } }

    Bunchball::Nitro::User.expects(:post).with("user.purchaseItem", params).returns(return_value)

    response = Bunchball::Nitro::User.purchase_item('wiggly', 'an_item')
    assert_equal response['Balance'], 'foo'
  end

  # Test the instance version of the same method
  def test_purchase_item_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:purchase_item).with(u.user_id, 'an_item', u.session).returns('foo')

    response = u.purchase_item('an_item')
    assert_equal response, 'foo'
  end

  def test_remove_avatar_item
    params = {:userId => 'a_user', :itemId => 'an item'}

    return_value = {'Nitro' => {'AvatarRecord' =>
        {'items' => 'foo'}
      }
    }

    Bunchball::Nitro::User.expects(:post).with('user.removeAvatarItem', params).returns(return_value)

    response = Bunchball::Nitro::User.remove_avatar_item('a_user', 'an item')
    assert_equal response['items'], 'foo'
  end

  def test_remove_avatar_item_instance
    u = setup_user

    Bunchball::Nitro::User.expects(:remove_avatar_item).with(u.user_id, 'an item', u.session).returns('foo')

    response = u.remove_avatar_item('an item')
    assert_equal response, 'foo'
  end

  def test_remove_preference
    params = {:userId => 'wiggly', :name => 'preference_name'}

    return_value = {'Nitro' => {'res' => 'ok', 'userPreferences' =>
        {'UserPreference' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.removePreference", params).returns(return_value)

    response = Bunchball::Nitro::User.remove_preference('wiggly', 'preference_name')
    assert_equal response['UserPreference'], 'foo'
  end

  def test_remove_preference_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:remove_preference).with('wibble', 'preference_name', :sessionKey => 'a_session_key').returns('foo')

    response = u.remove_preference('preference_name')
    assert_equal response, 'foo'
  end

  def test_reset_level
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => {'res' => 'ok', 'users' =>
        {'User' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.resetLevel", params).returns(return_value)

    response = Bunchball::Nitro::User.reset_level('wiggly')
    assert_equal response['User'], 'foo'
  end

  def test_reset_level_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:reset_level).with('wibble', :sessionKey => 'a_session_key').returns('foo')

    response = u.reset_level
    assert_equal response, 'foo'
  end

  def test_sellback_item
    # This one requires one of a pair of item id specifiers be present in params,
    # so we don't use a positional paramater for it. Just pick one for the test.
    params = {:userId => 'wiggly', :ownedItemId => 'owned_item'}

    return_value = {'Nitro' => {'res' => 'ok', 'OwnedItemsRecord' => 'foo' } }

    Bunchball::Nitro::User.expects(:post).with("user.sellbackItem", params).returns(return_value)

    response = Bunchball::Nitro::User.sellback_item('wiggly', :ownedItemId => 'owned_item')
    assert_equal response['OwnedItemsRecord'], 'foo'
  end

  # Test the instance version of the same method
  def test_sellback_item_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:sellback_item).with(u.user_id, {:itemId => 'an_item'}.merge(u.session)).returns('foo')

    response = u.sellback_item(:itemId => 'an_item')
    assert_equal response, 'foo'
  end

  def test_set_avatar_color
    params = {:userId => 'a_user', :instanceName => 'an instance', :skinColor => '33ffcc'}

    return_value = {'Nitro' => {'AvatarRecord' =>
        {'items' => 'foo'}
      }
    }

    Bunchball::Nitro::User.expects(:post).with('user.setAvatarColor', params).returns(return_value)

    response = Bunchball::Nitro::User.set_avatar_color('a_user', 'an instance', '33ffcc')
    assert_equal response['items'], 'foo'
  end

  def test_set_avatar_color_instance
    u = setup_user

    Bunchball::Nitro::User.expects(:set_avatar_color).with(u.user_id, 'an instance', '33ffaa', u.session).returns('foo')

    response = u.set_avatar_color('an instance', '33ffaa')
    assert_equal response, 'foo'
  end

  def test_set_level
    params = {:userId => 'wiggly', :levelName => 'level_name'}

    return_value = {'Nitro' => {'res' => 'ok', 'users' =>
        {'User' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.setLevel", params).returns(return_value)

    response = Bunchball::Nitro::User.set_level('wiggly', 'level_name')
    assert_equal response['User'], 'foo'
  end

  def test_set_level_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:set_level).with('wibble', 'level_name', :sessionKey => 'a_session_key').returns('foo')

    response = u.set_level('level_name')
    assert_equal response, 'foo'
  end

  def test_set_preference
    params = {:userId => 'wiggly', :name => 'preference_name'}

    return_value = {'Nitro' => {'res' => 'ok', 'userPreferences' =>
        {'UserPreference' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.setPreference", params).returns(return_value)

    response = Bunchball::Nitro::User.set_preference('wiggly', 'preference_name')
    assert_equal response['UserPreference'], 'foo'
  end

  def test_set_preference_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:set_preference).with('wibble', 'preference_name', :sessionKey => 'a_session_key').returns('foo')

    response = u.set_preference('preference_name')
    assert_equal response, 'foo'
  end

  def test_set_preferences
    params = {:userId => 'wiggly', :names => 'preference1|preference2'}

    return_value = {'Nitro' => {'res' => 'ok', 'userPreferences' =>
        {'UserPreference' => 'foo' }
      }
    }

    Bunchball::Nitro::User.expects(:post).with("user.setPreferences", params).returns(return_value)

    response = Bunchball::Nitro::User.set_preferences('wiggly', 'preference1|preference2')
    assert_equal response['UserPreference'], 'foo'
  end

  def test_set_preferences_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:set_preferences).with('wibble', 'preference1|preference2', :sessionKey => 'a_session_key').returns('foo')

    response = u.set_preferences('preference1|preference2')
    assert_equal response, 'foo'
  end

  def test_store_notifications
    params = {:userIds => 'wiggly,piggly', :notificationNames => 'notify1,notify2'}

    return_value = {'Nitro' => {'res' => 'ok'} }

    Bunchball::Nitro::User.expects(:post).with("user.storeNotifications", params).returns(return_value)

    response = Bunchball::Nitro::User.store_notifications('wiggly,piggly', 'notify1,notify2')
    assert_equal response, true  # want actual true here, not just a value that evals as true
  end

  def test_store_notifications_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:store_notifications).with('wibble', 'notify1', :sessionKey => 'a_session_key').returns('foo')

    response = u.store_notifications('notify1')
    assert_equal response, 'foo'
  end

  def test_transfer_points
    params = {:srcUserId => 'wiggly', :destUserId => 'puggly'}

    return_value = {'Nitro' => {'res' => 'ok'}}

    Bunchball::Nitro::User.expects(:post).with("user.transferPoints", params).returns(return_value)

    response = Bunchball::Nitro::User.transfer_points('wiggly', 'puggly')
    assert_equal response, true  # want actual true here, not just a value that evals as true
  end

  # Test the instance version of the same method
  def test_transfer_points_instance
    u = setup_user

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:transfer_points).with(u.user_id, 'puggly', u.session).returns('foo')

    response = u.transfer_points('puggly')
    assert_equal response, 'foo'
  end

end
