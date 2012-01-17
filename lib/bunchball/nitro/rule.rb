class Bunchball::Nitro::Rule
  attr_accessor :api_response

  def initialize(response = {})
    @api_response = response
  end

  def achieved
    @api_response['achieved'].to_i
  end

  def action_tag
    @api_response['actionTag']
  end

  def completed?
    @api_response['completed'] == 'true'
  end

  def description
    @api_response['description']
  end

  def goal
    @api_response['goal'].to_i
  end

  def operator
    @api_response['operator']
  end

  # Can't call this one 'type'; let's don't obscure built-in methods (even
  # deprecated ones).
  def rule_type
    @api_response['type']
  end

  def service_action_type
    @api_response['serviceActionType']
  end

  def service_type
    @api_response['serviceType']
  end

  def sort_order
    @api_response['sortOrder']
  end
end
