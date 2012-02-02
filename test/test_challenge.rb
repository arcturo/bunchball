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
    test_time = Time.now.to_i - 300
    challenge = make_challenge(sample_api_response.merge('startTime' => test_time))
    assert_equal challenge.start_time.class, Time
    assert_equal Time.at((test_time)), challenge.start_time
  end

  def test_end_time
    test_time = Time.now.to_i + 300
    challenge = make_challenge(sample_api_response.merge('endTime' => test_time))
    assert_equal challenge.end_time.class, Time
    assert_equal Time.at((test_time)), challenge.end_time
  end

  def test_trophy_url
    challenge = make_challenge(sample_api_response.merge('fullUrl' => 'foo'))
    assert_equal 'foo', challenge.trophy_url
  end

  def test_trophy_thumb_url
    challenge = make_challenge(sample_api_response.merge('thumbUrl' => 'foo'))
    assert_equal 'foo', challenge.trophy_thumb_url
  end
end
