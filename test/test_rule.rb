require 'test_helper'

class TestLevel < Test::Unit::TestCase
  def sample_api_response
    {
      'achieved' => '1',
      'actionTag' => 'TestAction1222288778860',
      'completed' => 'true',
      'description' => 'A test rule for testing',
      'goal' => '1',
      'operator' => 'EQ',
      'serviceType' => 'Service type',
      'type' => 'none'
    }
  end

  def make_rule(api_response = sample_api_response)
    Bunchball::Nitro::Rule.new(api_response)
  end

  def test_achieved
    rule = make_rule(sample_api_response.merge('achieved' => '3'))
    assert_equal rule.achieved, 3
  end

  def test_action_tag
    rule = make_rule(sample_api_response.merge('actionTag' => 'An Action Tag'))
    assert_equal rule.action_tag, 'An Action Tag'
  end

  def test_completed_true?
    rule = make_rule(sample_api_response.merge('completed' => 'true'))
    assert rule.completed?
  end

  def test_completed_false?
    rule = make_rule(sample_api_response.merge('completed' => 'false'))
    assert ! rule.completed?
  end

  def test_description
    rule = make_rule(sample_api_response.merge('description' => 'A test description'))
    assert_equal rule.description, 'A test description'
  end

  def test_goal
    rule = make_rule(sample_api_response.merge('goal' => '37'))
    assert_equal rule.goal, 37
  end

  def test_initialize
    rule = make_rule
    assert_equal rule.class, Bunchball::Nitro::Rule
  end

  def test_operator
    rule = make_rule(sample_api_response.merge('operator' => 'EQ'))
    assert_equal rule.operator, 'EQ'
  end

  def test_rule_type
    rule = make_rule(sample_api_response.merge('type' => 'value'))
    assert_equal rule.rule_type, 'value'
  end

  def test_service_action_type
    rule = make_rule(sample_api_response.merge('serviceActionType' => 'A service action type'))
    assert_equal rule.service_action_type, 'A service action type'
  end

  def test_service_type
    rule = make_rule(sample_api_response.merge('serviceType' => 'A service type'))
    assert_equal rule.service_type, 'A service type'
  end

  def test_sort_order
    rule = make_rule(sample_api_response.merge('sortOrder' => 'The last shall be first'))
    assert_equal rule.sort_order, 'The last shall be first'
  end
end
