require 'test_helper'

class TestGroup < Test::Unit::TestCase
  def teardown
    Bunchball::Nitro.logout
  end

  def base_keys
    {:sessionKey => '1234'}
  end

  def test_get_challenge_progress
    params = {:groupName => 'froggy'}

    return_value = {'Nitro' => {'res' => 'ok', 'challenges' =>
        {'Challenge' => {'completionCount' => '1', 'rules' => {'Rule' => {'goal' => '37'} } }}
      }
    }

    Bunchball::Nitro::Group.expects(:post).with("group.getChallengeProgress", params).returns(return_value)

    response = Bunchball::Nitro::Group.get_challenge_progress('froggy')
    assert response.payload.first.is_a? Bunchball::Nitro::Challenge
    assert_equal response.payload.first.rules.first.goal, 37
  end

  def test_get_users
    params = {:groupName => 'froggy'}

    return_value = {'Nitro' => {'users' => { 'User' => [ 
      { "UserPreferences" => true, "userId" => "willy@wonka.net" },
      { "UserPreferences" => true, "userId" => "bobby@bubbly.net" }
      ] } } }

    Bunchball::Nitro::Group.expects(:post).with("group.getUsers", params).returns(return_value)

    response = Bunchball::Nitro::Group.get_users("froggy")
    assert_equal "willy@wonka.net", response.payload['User'].first['userId']
  end
end
