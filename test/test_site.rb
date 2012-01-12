require 'test_helper'

class TestSite < Test::Unit::TestCase
  def teardown
    Bunchball::Nitro.logout
  end

  def base_keys
    {:sessionKey => '1234'}
  end

  def test_add_users_to_group
    params = {:userIds => 'user1,user2', :groupName => 'a_group'}

    return_value = {'Nitro' => {'res' => 'ok', 'groupUsers' =>
        {'GroupUsers' => 'foo'}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.addUsersToGroup', params).returns(return_value)

    response = Bunchball::Nitro::Site.add_users_to_group('user1,user2', 'a_group')
    assert_equal response.payload['GroupUsers'], 'foo'
  end

  def test_get_action_feed
    # Set key instead of mocking login
    Bunchball::Nitro.api_key = "1234"

    params = {:apiKey => Bunchball::Nitro.api_key}

    return_value = {'Nitro' => {'res' => 'ok', 'items' =>
        {'item' => 'foo'}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getActionFeed', params).returns(return_value)

    response = Bunchball::Nitro::Site.get_action_feed
    assert_equal response.payload['item'], 'foo'
  end

  def test_get_action_leaders
    params = {:criteria => 'sum', :tags => 'a_tag'}

    return_value = {'Nitro' => {'res' => 'ok', 'actions' =>
        {'Action' => 'foo'}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getActionLeaders', params).returns(return_value)

    response = Bunchball::Nitro::Site.get_action_leaders('sum', 'a_tag')
    assert_equal response.payload['Action'], 'foo'
  end

  def test_get_action_target_leaders
    # Set key instead of mocking login
    Bunchball::Nitro.session_key = "1234"

    params = {:criteria => 'sum', :tag => 'a_tag', :sessionKey => '1234'}

    return_value = {'Nitro' => {'res' => 'ok', 'targets' =>
        {'Target' => 'foo'}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getActionTargetLeaders', params).returns(return_value)

    response = Bunchball::Nitro::Site.get_action_target_leaders('sum', 'a_tag')
    assert_equal response.payload['Target'], 'foo'
  end

  def test_get_catalog
    # The way this API method returns data (and HTTParty parses it),
    # the 'CatalogRecord' can return a hash or an array of hashes.
    # But that doesn't matter too much for our mocking here, as it's
    # going to be up to the app to interpret the returned values anyway.
    return_value = {'Nitro' => {'res' => 'ok', 'CatalogRecord' =>
        {'categories' => {'Category' => ['foo_cat']},
         'catalogItems' => {'CatalogItem' => ['foo_item']}
        }
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getCatalog', {}).returns(return_value)

    response = Bunchball::Nitro::Site.get_catalog
    payload = response.payload
    assert_equal payload.keys.size, 2
    assert payload.has_key? 'categories'
    assert payload.has_key? 'catalogItems'
    assert payload['categories']['Category'].is_a? Array
    assert payload['catalogItems']['CatalogItem'].is_a? Array
  end

  def test_get_catalog_item
    params = {:itemId => 'an_item_id'}

    return_value = {'Nitro' => {'res' => 'ok', 'CatalogRecord' =>
        {'catalogItems' => {'CatalogItem' => 'foo'}}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getCatalogItem', params).returns(return_value)

    response = Bunchball::Nitro::Site.get_catalog_item('an_item_id')
    assert_equal response.payload, 'foo'
  end

  def test_get_challenge_leaders
    # Set key instead of mocking login
    Bunchball::Nitro.session_key = "1234"

    params = {:sessionKey => '1234'}

    return_value = {'Nitro' => {'res' => 'ok', 'challenges' =>
        {'Challenge' => 'foo'}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getChallengeLeaders', params).returns(return_value)

    response = Bunchball::Nitro::Site.get_challenge_leaders
    assert_equal response.payload['Challenge'], 'foo'
  end

  def test_get_group_points_leaders
    params = {}

    return_value = {'Nitro' => {'res' => 'ok', 'groupLeaders' =>
        {'groupLeader' => 'foo'}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getGroupPointsLeaders', params).returns(return_value)

    response = Bunchball::Nitro::Site.get_group_points_leaders
    assert_equal response.payload['groupLeader'], 'foo'
  end

  def test_get_group_action_leaders
    params = {:tags => 'a_tag,b_tag'}

    return_value = {'Nitro' => {'res' => 'ok', 'groupLeaders' =>
        {'groupLeader' => 'foo'}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getGroupActionLeaders', params).returns(return_value)

    response = Bunchball::Nitro::Site.get_group_action_leaders('a_tag,b_tag')
    assert_equal response.payload['groupLeader'], 'foo'
  end

  def test_get_levels
    return_value = {'Nitro' => {'res' => 'ok', 'siteLevels' =>
        {'SiteLevel' => 'foo'}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getLevels', {}).returns(return_value)

    response = Bunchball::Nitro::Site.get_levels
    assert_equal response.payload, 'foo'
  end

  def test_get_points_leaders
    # Set key instead of mocking login
    Bunchball::Nitro.session_key = "1234"

    params = {:sessionKey => '1234'}

    return_value = {'Nitro' => {'res' => 'ok', 'leaders' =>
        {'Leader' => 'foo'}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getPointsLeaders', params).returns(return_value)

    response = Bunchball::Nitro::Site.get_points_leaders
    assert_equal response.payload['Leader'], 'foo'
  end

  def test_get_recent_actions
    # Set key instead of mocking login
    Bunchball::Nitro.session_key = "1234"

    params = {:sessionKey => '1234'}

    return_value = {'Nitro' => {'res' => 'ok', 'actions' =>
        {'Action' => 'foo'}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getRecentActions', params).returns(return_value)

    response = Bunchball::Nitro::Site.get_recent_actions
    assert_equal response.payload['Action'], 'foo'
  end

  def test_get_recent_challenges
    # Set key instead of mocking login
    Bunchball::Nitro.session_key = "1234"

    params = {:sessionKey => '1234'}

    return_value = {'Nitro' => {'res' => 'ok', 'challenges' =>
        {'Challenge' => {'name' => 'A challenge', 'rules' => {'Rule' => 'foo' } }}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getRecentChallenges', params).returns(return_value)

    response = Bunchball::Nitro::Site.get_recent_challenges
    assert response.payload.first.is_a? Bunchball::Nitro::Challenge
    assert_equal response.payload.first.rules, ['foo']
  end

  def test_get_recent_updates
    # Set key instead of mocking login
    Bunchball::Nitro.session_key = "1234"

    params = {:criteria => 'sum', :sessionKey => '1234'}

    return_value = {'Nitro' => {'res' => 'ok', 'updates' =>
        {'Update' => 'foo'}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getRecentUpdates', params).returns(return_value)

    response = Bunchball::Nitro::Site.get_recent_updates('sum')
    assert_equal response.payload['Update'], 'foo'
  end

  def test_remove_users_from_group
    params = {:userIds => 'user1,user2', :groupName => 'a_group'}

    return_value = {'Nitro' => {'res' => 'ok', 'groupUsers' =>
        {'GroupUsers' => 'foo'}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.removeUsersFromGroup', params).returns(return_value)

    response = Bunchball::Nitro::Site.remove_users_from_group('user1,user2', 'a_group')
    assert_equal response.payload['GroupUsers'], 'foo'
  end

end
