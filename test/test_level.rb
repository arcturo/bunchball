require 'test_helper'

class TestLevel < Test::Unit::TestCase
  def sample_api_response
    { "iconUrl" => "http://assets.bunchball.com/widgets/staticimages/poker/levels/11_marksmanIcon.png",
      "name" => "Marksman",
      "timestamp" => "0",
      "points" => "2500",
      "type" => "points",
      "description" => "Marksman"
    }
  end

  def make_level(api_response = sample_api_response)
    Bunchball::Nitro::Level.new(api_response)
  end

  def test_has_icon?
    level = make_level(sample_api_response.merge('iconUrl' => 'foo'))
    assert level.has_icon?
  end

  def test_description
    level = make_level(sample_api_response.merge('description' => 'A description'))
    assert_equal level.description, 'A description'
  end

  def test_icon_url
    level = make_level(sample_api_response.merge('iconUrl' => 'Duke of'))
    assert_equal level.icon_url, 'Duke of'
  end

  def test_initialize
    level = make_level
    assert_equal level.class, Bunchball::Nitro::Level
  end

  def test_level_type
    level = make_level(sample_api_response.merge('type' => 'Type A'))
    assert_equal level.level_type, 'Type A'
  end

  def test_name
    level = make_level(sample_api_response.merge('name' => 'foo'))
    assert_equal level.name, 'foo'
  end

  def test_points
    level = make_level(sample_api_response.merge('points' => '100'))
    assert_equal level.points, 100
  end

  def test_timestamp
    level = make_level(sample_api_response.merge('timestamp' => Time.now.to_i - 300))
    assert_equal level.timestamp, (Time.now.to_i - 300)
  end

end
