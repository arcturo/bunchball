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
