class Bunchball::Nitro::Level
  attr_accessor :api_response

  def initialize(response = {})
    @api_response = response
  end

  def has_icon?
    !! @api_response['iconUrl']
  end

  def description
    @api_response['description']
  end

  def icon_url
    @api_response['iconUrl']
  end

  # Can't call this one 'type'; let's don't obscure built-in methods (even
  # deprecated ones).
  def level_type
    @api_response['type']
  end

  def name
    @api_response['name']
  end

  def points
    @api_response['points'].to_i
  end

  def timestamp
    @api_response['timestamp'].to_i
  end

end
