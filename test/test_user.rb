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

  def test_modify_user_id
    params = {:oldUserId => 'wiggly', :newUserId => 'puggly'}

    return_value = {'Nitro' => {'res' => 'ok'}}

    Bunchball::Nitro::User.expects(:post).with("user.modifyUserId", params).returns(return_value)

    response = Bunchball::Nitro::User.modify_user_id('wiggly', 'puggly')
    assert_equal response, true  # want actual true here, not just a value that evals as true
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
end
