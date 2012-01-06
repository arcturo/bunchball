require 'test_helper'

class TestResponse < Test::Unit::TestCase

  def make_response(api_response)
    Bunchball::Nitro::Response.new(api_response)
  end

  def test_initialize
    response = make_response({'Nitro' => {'res' => 'ok', 'groupUsers' => {'GroupUsers' => 'foo'} } })
    assert_equal response.class, Bunchball::Nitro::Response
  end

  def test_valid
    response = make_response({'Nitro' => {'res' => 'ok', 'groupUsers' => {'GroupUsers' => 'foo'} } })
    assert response.valid?
  end

  def test_invalid
    response = make_response({'Nitro' => {'res' => 'err', 'groupUsers' => {'GroupUsers' => 'foo'} } })
    assert ! response.valid?
  end

  def test_error_nil
    response = make_response({'Nitro' => {'res' => 'ok', 'groupUsers' => {'GroupUsers' => 'foo'} } })
    assert response.errors.empty?
  end

  def test_errors
    response = make_response({'Nitro' => {'res' => 'err', 'Error' => {'GroupUsers' => 'foo'} } })
    assert_not_nil response.errors
  end

  def test_errors_bogus
    # Make sure that we just ignore 'Error' value if 'res' is 'ok'
    response = make_response({'Nitro' => {'res' => 'ok', 'Error' => {'GroupUsers' => 'foo'} } })
    assert response.errors.empty?
  end
end
