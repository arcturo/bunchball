$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require "test/unit"
require "bunchball"
require "mocha"

API_TEST_URL = 'http://sandbox.bunchball.net/nitro/json'

class Test::Unit::TestCase
  def teardown
    super
    Mocha::Mockery.instance.teardown
    Mocha::Mockery.reset_instance    
  end
end
