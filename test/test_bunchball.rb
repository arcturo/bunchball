require 'test_helper'

class TestBunchball < Test::Unit::TestCase
  def teardown
    Bunchball::Nitro.logout
  end

  def test_login
    HTTParty.expects(:post).with(api_url, :body => {:method => "user.login", :userId => "winnerwinner@chickendinner.com", :apiKey => "1234"}).returns({'Nitro' => {'Login' => {'sessionKey' => 'winning'}}})

    response = Bunchball::Nitro.login("winnerwinner@chickendinner.com", "1234")
    assert_equal "winning", response
  end
end
