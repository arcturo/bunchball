require 'test_helper'

class TestBunchball < Test::Unit::TestCase
  def test_login
    HTTParty.expects(:post).with("http://sandbox.bunchball.net/nitro/json", :body => {:method => "user.login", :userId => "winnerwinner@chickendinner.com", :apiKey => "1234"}).returns({'Nitro' => {'Login' => {'sessionKey' => 'winning'}}})

    response = Bunchball::Nitro.login("winnerwinner@chickendinner.com", "1234")
    assert_equal "winning", response
  end
end
