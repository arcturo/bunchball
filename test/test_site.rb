require 'test_helper'

class TestSite < Test::Unit::TestCase
  def teardown
    Bunchball::Nitro.logout
  end

  def base_keys
    {:sessionKey => '1234'}
  end

  def test_get_levels
    return_value = {'Nitro' => {'res' => 'ok', 'siteLevels' =>
        {'SiteLevel' => ['foo']}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getLevels', {}).returns(return_value)

    response = Bunchball::Nitro::Site.get_levels
    assert_equal response.first, 'foo'
  end

end
