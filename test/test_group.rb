require 'test_helper'

class TestGroup < Test::Unit::TestCase
  def teardown
    Bunchball::Nitro.logout
  end

  def base_keys
    {:sessionKey => '1234'}
  end

  def test_foo
    true
  end

  def test_get_users
    # Set keys instead of mocking login
    Bunchball::Nitro.session_key = "1234"

    params = Bunchball::Nitro::Group.session.merge({:groupName => "froggy"})

    return_value = {'Nitro' => {'users' => { 'User' => [ 
      { "UserPreferences" => true, "userId" => "willy@wonka.net" },
      { "UserPreferences" => true, "userId" => "bobby@bubbly.net" }
      ] } } }

    Bunchball::Nitro::Group.expects(:post).with("group.getUsers", params).returns(return_value)

    response = Bunchball::Nitro::Group.get_users("froggy")
    assert_equal "willy@wonka.net", response['User'].first['userId']
  end
end
