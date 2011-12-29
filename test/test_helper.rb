$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require "test/unit"
require "bunchball"
require "mocha"

class Test::Unit::TestCase
  def api_url
    'http://sandbox.bunchball.net/nitro/json'
  end
end
