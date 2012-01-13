require 'test_helper'

class TestChallenge < Test::Unit::TestCase
  def sample_api_response
    {
              "groupFlag" => "0",
                   "name" => "Watch a Video on Christmas Day and get a special present! Available to Sharks only!",
        "groupPointAward" => "0",
             "pointAward" => "0",
                  "rules" => {
                    "Rule" => {
                     "goal" => "1",
                "completed" => "false",
                 "operator" => "EQ",
                     "type" => "none",
        "serviceActionType" => "none",
              "serviceType" => "nitro",
              "description" => "Watch a Video on Christmas Day!",
                 "achieved" => "0",
                "actionTag" => "Video_Watch",
                "sortOrder" => "0"
                    }
                  },
                  "level" => "Shark",
          "pointCategory" => "Points",
          "ruleMatchType" => "0",
        "catalogItemName" => "Gary",
             "dateIssued" => "1324800000",
                   "tags" => "",
  "dailyAchievementLimit" => "0",
            "description" => "Look on the Advanced Tab to see the date range set and the Level requirement. Rewards a virtual item for Watching a Video on Christmas Day.",
        "completionCount" => "0",
              "startTime" => "1324800000",
                "endTime" => "1324886400",
            "serviceType" => "1",
        "applyMultiplier" => "0",
             "repeatable" => "0",
        "hideUntilEarned" => "0"
    }
  end

  def make_challenge(api_response = sample_api_response)
    Bunchball::Nitro::Challenge.new(api_response)
  end

  def test_active?
    challenge = make_challenge(sample_api_response.merge('startTime' => Time.now.to_i - 3600,
                                                         'endTime' => Time.now.to_i + 3600))
    assert challenge.active?
  end

  def test_active_after_end
    challenge = make_challenge(sample_api_response.merge('startTime' => Time.now.to_i - 3600,
                                                         'endTime' => Time.now.to_i - 100))

    assert ! challenge.active?
  end

  def test_active_before_start
    challenge = make_challenge(sample_api_response.merge('startTime' => Time.now.to_i + 3600,
                                                         'endTime' => Time.now.to_i + 7200))

    assert ! challenge.active?
  end

  def test_initialize
    challenge = make_challenge
    assert_equal challenge.class, Bunchball::Nitro::Challenge
  end

  def test_completed?
    challenge = make_challenge(sample_api_response.merge('dateCompleted' => Time.now.to_i-30))
    assert challenge.completed?
  end

  def test_date_completed
    challenge = make_challenge(sample_api_response.merge('dateCompleted' => Time.now.to_i-30))
    assert_equal challenge.date_completed.class, Time
  end

  def test_date_completed_when_not_completed
    api_response = sample_api_response
    api_response.delete('dateCompleted')
    challenge = make_challenge(api_response)
    assert ! challenge.completed?
    assert_nil challenge.date_completed
  end

  def test_has_trophy?
    challenge = make_challenge(sample_api_response.merge('fullUrl' => 'foo'))
    assert challenge.has_trophy?
    challenge = make_challenge(sample_api_response.merge('thumbUrl' => 'foo'))
    assert challenge.has_trophy?
  end

  def test_name
    challenge = make_challenge(sample_api_response.merge('name' => 'foo'))
    assert_equal challenge.name, 'foo'
  end

  def test_point_award
    challenge = make_challenge(sample_api_response.merge('pointAward' => '75'))
    assert_equal challenge.point_award, 75
  end

  def test_rules
    challenge = make_challenge(sample_api_response)
    assert challenge.rules.is_a? Array
  end

  def test_start_time
    challenge = make_challenge(sample_api_response.merge('startTime' => Time.now.to_i - 300))
    assert_equal challenge.start_time.class, Time
    assert_equal challenge.start_time, Time.at((Time.now.to_i - 300))
  end

  def test_end_time
    challenge = make_challenge(sample_api_response.merge('endTime' => Time.now.to_i + 300))
    assert_equal challenge.end_time.class, Time
    assert_equal challenge.end_time.class, Time
  end

  def test_trophy_url
    challenge = make_challenge(sample_api_response.merge('fullUrl' => 'foo'))
    assert_equal 'foo', challenge.trophy_url
  end

  def test_trophy_thumb_url
    challenge = make_challenge(sample_api_response.merge('thumbUrl' => 'foo'))
    assert_equal 'foo', challenge.trophy_thumb_url
  end

  # 
  # def test_valid
  #   response = make_response({'Nitro' => {'res' => 'ok', 'groupUsers' => {'GroupUsers' => 'foo'} } })
  #   assert response.valid?
  # end
  # 
  # def test_invalid
  #   response = make_response({'Nitro' => {'res' => 'err', 'groupUsers' => {'GroupUsers' => 'foo'} } })
  #   assert ! response.valid?
  # end
  # 
  # def test_error_nil
  #   response = make_response({'Nitro' => {'res' => 'ok', 'groupUsers' => {'GroupUsers' => 'foo'} } })
  #   assert response.errors.empty?
  # end
  # 
  # def test_errors
  #   response = make_response({'Nitro' => {'res' => 'err', 'Error' => {'GroupUsers' => 'foo'} } })
  #   assert_not_nil response.errors
  # end
  # 
  # def test_errors_bogus
  #   # Make sure that we just ignore 'Error' value if 'res' is 'ok'
  #   response = make_response({'Nitro' => {'res' => 'ok', 'Error' => {'GroupUsers' => 'foo'} } })
  #   assert response.errors.empty?
  # end
  # 
  # def test_method
  #   response = make_response({'Nitro' => {'res' => 'ok', 'server' => 'froggy.com', 'method' => 'a_method' } })
  #   assert_equal response.method, 'a_method'
  # end
  # 
  # def test_nitro
  #   api_response = {'Nitro' => {'res' => 'ok', 'server' => 'froggy.com', 'method' => 'a_method' } }
  #   response = make_response(api_response)
  #   assert_equal response.nitro, api_response['Nitro']
  # end
  # 
  # def test_payload_default
  #   api_response = {'Nitro' => {'res' => 'ok', 'server' => 'froggy.com', 'method' => 'a_method' } }
  #   response = make_response(api_response)
  #   assert_equal response.payload, response.nitro
  # end
  # 
  # def test_payload_set
  #   api_response = {'Nitro' => {'res' => 'ok', 'server' => 'froggy.com', 'method' => 'a_method',
  #                   'UserResult' => 'foo'
  #                  } }
  #   response = make_response(api_response)
  #   response.payload = response.nitro['UserResult']
  #   assert_equal response.payload, 'foo'
  # end
  # 
  # def test_res
  #   response = make_response({'Nitro' => {'res' => 'poo' } })
  #   assert_equal response.res, 'poo'
  # end
  # 
  # def test_server
  #   response = make_response({'Nitro' => {'res' => 'ok', 'server' => 'froggy.com' } })
  #   assert_equal response.server, 'froggy.com'
  # end
  # 
end
