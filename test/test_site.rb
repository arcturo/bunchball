require 'test_helper'

class TestSite < Test::Unit::TestCase
  def teardown
    Bunchball::Nitro.logout
  end

  def base_keys
    {:sessionKey => '1234'}
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
    assert_equal response.keys.size, 2
    assert response.has_key? 'categories'
    assert response.has_key? 'catalogItems'
    assert response['categories']['Category'].is_a? Array
    assert response['catalogItems']['CatalogItem'].is_a? Array
  end

  def test_get_catalog_item
    params = {:itemId => 'an_item_id'}

    return_value = {'Nitro' => {'res' => 'ok', 'CatalogRecord' =>
        {'catalogItems' => {'CatalogItem' => 'foo'}}
      }
    }

    Bunchball::Nitro::Site.expects(:post).with('site.getCatalogItem', params).returns(return_value)

    response = Bunchball::Nitro::Site.get_catalog_item('an_item_id')
    assert_equal response, 'foo'
  end

  def self.get_catalog_item(item_id, params = {})
    response = post("site.getCatalogItem", {:itemId => item_id}.merge(params))
    item = response['Nitro']['CatalogRecord']['catalogItems']['CatalogItem'] rescue nil
    return item
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
