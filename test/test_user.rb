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

    u = Bunchball::Nitro::User.modify_user_id('wiggly', 'puggly')
    assert_equal u, true  # want actual true here, not just a value that evals as true
  end

  def test_award_challenge
    HTTParty.expects(:post).with(api_url, :body => {:method => "user.login", :userId => "winnerwinner@chickendinner.com", :apiKey => "1234"}).returns({'Nitro' => {'Login' => {'sessionKey' => 'winning'}}})

    response = Bunchball::Nitro.login("winnerwinner@chickendinner.com", "1234")
    assert_equal "winning", response
  end
end
