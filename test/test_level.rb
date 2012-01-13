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

  def test_initialize
    level = make_level
    assert_equal level.class, Bunchball::Nitro::Level
  end

  # def test_has_trophy?
  #   challenge = make_challenge(sample_api_response.merge('fullUrl' => 'foo'))
  #   assert challenge.has_trophy?
  #   challenge = make_challenge(sample_api_response.merge('thumbUrl' => 'foo'))
  #   assert challenge.has_trophy?
  # end

  def test_name
    level = make_level(sample_api_response.merge('name' => 'foo'))
    assert_equal level.name, 'foo'
  end

  # def test_point_award
  #   challenge = make_challenge(sample_api_response.merge('pointAward' => '75'))
  #   assert_equal challenge.point_award, 75
  # end
  # 
  # def test_start_time
  #   challenge = make_challenge(sample_api_response.merge('startTime' => Time.now.to_i - 300))
  #   assert_equal challenge.start_time.class, Time
  #   assert_equal challenge.start_time, Time.at((Time.now.to_i - 300))
  # end
  # 
  # def test_end_time
  #   challenge = make_challenge(sample_api_response.merge('endTime' => Time.now.to_i + 300))
  #   assert_equal challenge.end_time.class, Time
  #   assert_equal challenge.end_time.class, Time
  # end
  # 
  # def test_trophy_url
  #   challenge = make_challenge(sample_api_response.merge('fullUrl' => 'foo'))
  #   assert_equal 'foo', challenge.trophy_url
  # end
  # 
  # def test_trophy_thumb_url
  #   challenge = make_challenge(sample_api_response.merge('thumbUrl' => 'foo'))
  #   assert_equal 'foo', challenge.trophy_thumb_url
  # end
end
