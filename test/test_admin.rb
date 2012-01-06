require 'test_helper'

class TestAdmin < Test::Unit::TestCase
  def teardown
    Bunchball::Nitro.logout
  end

  def base_keys
    {:sessionKey => '1234'}
  end

  def test_create_action_tag
    params = {:name => "twinkle"}

    return_value = {'Nitro' => {'tags' =>
        { 'Tag' => 'foo' }
      }
    }

    Bunchball::Nitro::Admin.expects(:post).with("admin.createActionTag", params).returns(return_value)

    response = Bunchball::Nitro::Admin.create_action_tag('twinkle')
    assert_equal response['Tag'], 'foo'
  end

  def test_create_challenge
    params = {:name => "twinkle", :pointAward => 80, :activeFlag => 1}

    return_value = {'Nitro' => {'challenges' => {'Challenge' =>  
        {"groupFlag"=>"0", "name"=>"twinkle", "groupPointAward"=>"0", "activeFlag"=>"1", "pointAward"=>"80", "rules"=>true, "order"=>"0", "id"=>"3988448", "ruleMatchType"=>"0", "dateIssued"=>"1325219909", "tags"=>"", "dailyAchievementLimit"=>"0", "callbackFlag"=>"0", "startTime"=>"1325219909", "endTime"=>"0", "serviceType"=>"1", "pointCategoryId"=>"283426", "applyMultiplier"=>"0", "repeatable"=>"0", "hideUntilEarned"=>"0"}
      } } }

    Bunchball::Nitro::Admin.expects(:post).with("admin.createChallenge", params).returns(return_value)

    response = Bunchball::Nitro::Admin.create_challenge('twinkle', :pointAward => 80, :activeFlag => 1)
    assert_equal 'twinkle', response['Challenge']['name']
    assert_equal '80', response['Challenge']['pointAward']
  end

  def test_create_rule
    params = {:type => 'timeRange'}

    return_value = {'Nitro' => {'challenges' =>
        { 'Challenge' => 'foo' }
      }
    }

    Bunchball::Nitro::Admin.expects(:post).with("admin.createRule", params).returns(return_value)

    response = Bunchball::Nitro::Admin.create_rule('timeRange')
    assert_equal response['Challenge'], 'foo'
  end

  def test_create_rule_with_invalid_type
    response = Bunchball::Nitro::Admin.create_rule('bloglypoo')
    assert_equal response, nil
  end

  def test_get_action_tags
    params = {}

    return_value = {'Nitro' => {'res' => 'ok', 'tags' =>
        { 'Tag' => 'foo' }
      }
    }

    Bunchball::Nitro::Admin.expects(:post).with('admin.getActionTags', params).returns(return_value)

    response = Bunchball::Nitro::Admin.get_action_tags
    assert_equal response, 'foo'
  end

  def test_get_challenges
    params = {}

    return_value = {'Nitro' => {'res' => 'ok', 'challenges' =>
        { 'Challenge' => 'foo' }
      }
    }

    Bunchball::Nitro::Admin.expects(:post).with('admin.getChallenges', params).returns(return_value)

    response = Bunchball::Nitro::Admin.get_challenges
    assert_equal response['Challenge'], 'foo'
  end

  def test_login_admin
    body_params = {:method => 'admin.loginAdmin', :userId => 'winnerwinner@chickendinner.com',
                   :password => 'password', :apiKey => "1234"}
    return_value = {'Nitro' => {'Login' => {'sessionKey' => 'winning'}}}

    HTTParty.expects(:post).with(api_url, :body => body_params).returns(return_value)

    response = Bunchball::Nitro.login_admin('winnerwinner@chickendinner.com', 'password', '1234')
    assert_equal 'winning', response
  end

end
