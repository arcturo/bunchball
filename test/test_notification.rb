require 'test_helper'

class TestNotification < Test::Unit::TestCase

  def sample_notification_style
    {
      "html" => "{{notification_setting_Message|Congratulations! You just completed the {nitro_challenge} challenge and earned {nitro_points} {nitro_pointCategory}!|string}}",
      "name" => "Mobile Trophy Awarded Style"
    }
  end

  def sample_notification
    {
      "action" => "TEST_MOBILE_NOTIFICATION_FLOW",
      "balance" => "1227",
      "challenge" => "Test Mobile Notification Flow",
      "challengeTrophyFullUrl" => "http://www.collectiblebadges.com/media/large_crime_scene_investigator_badge_gold.jpg",
      "challengeTrophyThumbUrl" => "http://www.collectiblebadges.com/media/large_crime_scene_investigator_badge_gold.jpg",
      "doShare" => "0",
      "lifetimeBalance" => "1352",
      "name" => "Mobile Trophy Challenge Completed",
      "newsfeed" => "null",
      "pointCategory" => "Points",
      "pointCategoryIconUrl" => "",
      "pointCategoryLimit" => "25",
      "pointCategoryShort" => "Pts",
      "points" => "25",
      "styleName" => "Mobile Trophy Awarded Style",
      "timestamp" => "1328207836",
      "updated" => "1328138000",
      "userId" => "melinda@newsit.net",
      "value" => "0",
      "version" => "0",
      "notificationSettings" => {
        "NotificationSetting" => [
          { "name" => "Delay (secs)",
            "value" => "0"
          },
          { "name" => "Duration (secs)",
            "value" => "5"
          },
          { "name" => "Frequency",
            "value" => "Unlimited"
          },
          { "name" => "Corner",
            "value" => "Bottom Right"
          },
          { "name" => "Direction",
            "value" => "Vertical"
          },
          { "name" => "Message",
            "value" => "Congratulations! You just completed the {nitro_challenge} challenge and earned {nitro_points} {nitro_pointCategory}!"
          }
        ]
      }
    }
  end

  def make_notification(notify = sample_notification, notify_style = sample_notification_style)
    Bunchball::Nitro::Notification.new(notify, notify_style)
  end

  def test_action
    notification = make_notification(sample_notification.merge('action' => 'Wobbly'))
    assert_equal 'Wobbly', notification.action
  end

  def test_balance
    notification = make_notification(sample_notification.merge('balance' => '75'))
    assert_equal notification.balance, 75
  end

  def test_challenge
    notification = make_notification(sample_notification.merge('challenge' => 'Wobbly'))
    assert_equal 'Wobbly', notification.challenge
  end

  def test_do_share
    notification = make_notification(sample_notification.merge('doShare' => 'Wobbly'))
    assert_equal 'Wobbly', notification.do_share
  end

  def test_has_trophy?
    notification = make_notification(sample_notification.merge('challengeTrophyThumbUrl' => 'foo'))
    assert notification.has_trophy?
    notification = make_notification(sample_notification.merge('challengeTrophyFullUrl' => 'foo'))
    assert notification.has_trophy?
  end

  def test_initialize
    notification = make_notification
    assert_equal notification.class, Bunchball::Nitro::Notification
  end

  def test_lifetime_balance
    notification = make_notification(sample_notification.merge('lifetimeBalance' => '75'))
    assert_equal notification.lifetime_balance, 75
  end

  def test_name
    notification = make_notification(sample_notification.merge('name' => 'Wobbly'))
    assert_equal 'Wobbly', notification.name
  end

  def test_newsfeed
    notification = make_notification(sample_notification.merge('newsfeed' => 'Wobbly'))
    assert_equal 'Wobbly', notification.newsfeed
  end

  def test_notification_settings
    notification = make_notification(sample_notification.merge('notificationSettings' => 'Wobbly'))
    assert_equal 'Wobbly', notification.notification_settings
  end

  def test_point_category
    notification = make_notification(sample_notification.merge('pointCategory' => 'Wobbly'))
    assert_equal 'Wobbly', notification.point_category
  end

  def test_point_category_icon_url
    notification = make_notification(sample_notification.merge('pointCategoryIconUrl' => 'foo'))
    assert_equal 'foo', notification.point_category_icon_url
  end

  def test_point_category_limit
    notification = make_notification(sample_notification.merge('pointCategoryLimit' => '75'))
    assert_equal notification.point_category_limit, 75
  end

  def test_point_category_short
    notification = make_notification(sample_notification.merge('pointCategoryShort' => 'Wobbly'))
    assert_equal 'Wobbly', notification.point_category_short
  end

  def test_points
    notification = make_notification(sample_notification.merge('points' => '75'))
    assert_equal notification.points, 75
  end

  def test_style_name
    notification = make_notification(sample_notification.merge('styleName' => 'Wobbly'))
    assert_equal 'Wobbly', notification.style_name
  end

  def test_timestamp
    test_time = Time.now.to_i - 3600
    notification = make_notification(sample_notification.merge('timestamp' => test_time))
    assert notification.timestamp.is_a? Time
    assert_equal Time.at(test_time), notification.timestamp
  end

  def test_trophy_url
    notification = make_notification(sample_notification.merge('challengeTrophyFullUrl' => 'foo'))
    assert_equal 'foo', notification.trophy_url
  end

  def test_trophy_thumb_url
    notification = make_notification(sample_notification.merge('challengeTrophyThumbUrl' => 'foo'))
    assert_equal 'foo', notification.trophy_thumb_url
  end

  def test_updated
    test_time = Time.now.to_i - 3600
    notification = make_notification(sample_notification.merge('updated' => test_time))
    assert notification.updated.is_a? Time
    assert_equal Time.at(test_time), notification.updated
  end

  def test_user
    notification = make_notification(sample_notification.merge('userId' => 'foo'))
    assert notification.user.is_a? Bunchball::Nitro::User
    assert_equal 'foo', notification.user.user_id
  end

  def test_user_id
    notification = make_notification(sample_notification.merge('userId' => 'foo'))
    assert_equal 'foo', notification.user_id
  end

  def test_value
    notification = make_notification(sample_notification.merge('value' => '75'))
    assert_equal notification.value, 75
  end

  def test_version
    notification = make_notification(sample_notification.merge('version' => '75'))
    assert_equal notification.version, 75
  end
end
