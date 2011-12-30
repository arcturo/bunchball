require 'test_helper'

class TestAdmin < Test::Unit::TestCase
  def teardown
    Bunchball::Nitro.logout
  end

  def base_keys
    {:sessionKey => '1234'}
  end

  def test_create_challenge
    # Set keys instead of mocking login
    Bunchball::Nitro.session_key = "1234"

    params = Bunchball::Nitro::Admin.session.merge({:name => "twinkle", :pointAward => 80, :activeFlag => 1})

    return_value = {'Nitro' => {'challenges' => {'Challenge' =>  
        {"groupFlag"=>"0", "name"=>"twinkle", "groupPointAward"=>"0", "activeFlag"=>"1", "pointAward"=>"80", "rules"=>true, "order"=>"0", "id"=>"3988448", "ruleMatchType"=>"0", "dateIssued"=>"1325219909", "tags"=>"", "dailyAchievementLimit"=>"0", "callbackFlag"=>"0", "startTime"=>"1325219909", "endTime"=>"0", "serviceType"=>"1", "pointCategoryId"=>"283426", "applyMultiplier"=>"0", "repeatable"=>"0", "hideUntilEarned"=>"0"}
      } } }

    Bunchball::Nitro::Admin.expects(:post).with("admin.createChallenge", params).returns(return_value)

    response = Bunchball::Nitro::Admin.create_challenge('twinkle', :pointAward => 80, :activeFlag => 1)
    assert_equal 'twinkle', response['Challenge']['name']
    assert_equal '80', response['Challenge']['pointAward']
  end
end
