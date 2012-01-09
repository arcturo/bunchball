require 'test_helper'

class TestActions < Test::Unit::TestCase

  def test_hello
    return_value = { "Nitro" => { "res" => "ok", "method" => "hello",
                                  "server" => "sb00.prod.bunchball.net/nitro4.2.0",
                                  "asyncToken"=>"3-30-30-33-30-30-33-30-30"
                                }
                   }

    Bunchball::Nitro::Actions.expects(:post).with("hello").returns(return_value)

    response = Bunchball::Nitro::Actions.hello
    assert response.valid?
  end

  def test_status
    return_value = { "Nitro" => { "res" => "ok", "method" => "server.status",
                                  "server" => "sb00.prod.bunchball.net/nitro4.2.0",
                                  "asyncToken"=>"3-30-30-33-30-30-33-30-30"
                                }
                   }

    Bunchball::Nitro::Actions.expects(:post).with("server.status").returns(return_value)

    response = Bunchball::Nitro::Actions.status
    assert response.valid?
  end
end
