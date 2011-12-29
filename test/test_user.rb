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
    HTTParty.expects(:post).with(api_url, :body => {:method => "user.login", :userId => "winnerwinner@chickendinner.com", :apiKey => "1234"}).returns({'Nitro' => {'Login' => {'sessionKey' => 'winning'}}})

    response = Bunchball::Nitro.login("winnerwinner@chickendinner.com", "1234")
    assert_equal "winning", response
  end
end
