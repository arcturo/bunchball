require 'test_helper'

class TestUser < Test::Unit::TestCase
  def teardown
    Bunchball::Nitro.logout
  end

  def test_initialize
    Bunchball::Nitro.expects(:authenticate).with("wibble").returns('winning')

    u = Bunchball::Nitro::User.new('wibble')
    assert_equal u.session[:sessionKey], 'winning' # heh
  end

  def test_award_challenge
    # Set keys instead of mocking login
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

  def test_exists
    params = {:userId => 'wiggly'}

    return_value = {'Nitro' => {'Exists' => 'true'}}

    Bunchball::Nitro::User.expects(:post).with("user.exists", params).returns(return_value)

    response = Bunchball::Nitro::User.exists('wiggly')
    assert_equal response, true
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
    Bunchball::Nitro.expects(:authenticate).with("wibble").returns('a_session_key')

    u = Bunchball::Nitro::User.new('wibble')

    # Mock out the class method with the added params
    Bunchball::Nitro::User.expects(:get_points_balance).with('wibble', :sessionKey => 'a_session_key').returns('foo')

    response = u.get_points_balance
    assert_equal response, 'foo'
  end

  def test_modify_user_id
    params = {:oldUserId => 'wiggly', :newUserId => 'puggly'}

    return_value = {'Nitro' => {'res' => 'ok'}}

    Bunchball::Nitro::User.expects(:post).with("user.modifyUserId", params).returns(return_value)

    response = Bunchball::Nitro::User.modify_user_id('wiggly', 'puggly')
    assert_equal response, true  # want actual true here, not just a value that evals as true
  end

  def test_transfer_points
    params = {:srcUserId => 'wiggly', :destUserId => 'puggly'}

    return_value = {'Nitro' => {'res' => 'ok'}}

    Bunchball::Nitro::User.expects(:post).with("user.transferPoints", params).returns(return_value)

    response = Bunchball::Nitro::User.transfer_points('wiggly', 'puggly')
    assert_equal response, true  # want actual true here, not just a value that evals as true
  end

end
