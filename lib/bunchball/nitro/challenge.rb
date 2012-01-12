class Bunchball::Nitro::Challenge
  attr_accessor :api_response

  def initialize(response)
    @api_response = response
  end

  # Uncompleted challenges don't get a dateCompleted field at all from the API
  def completed?
    @api_response['dateCompleted']
  end

  def date_completed
    Time.at(@api_response['dateCompleted'].to_i) if self.completed?
  end

  def errors
    # There should not BE an 'Error' key on a valid API call response, but if
    # there is, we sure don't want to return it as if the call was invalid.
    # TODO: Should this return nil or []?
    return [] if self.valid?
    nitro['Error'] rescue []
  end

  def has_trophy?
    @api_response['fullUrl'] || @api_response['thumbUrl']
  end

  def name
    @api_response['name']
  end

  # Make sure we return an enumerable for the rules applying to this challenge,
  # even if there are none.
  #
  # TODO: Make these into Rule objects. Also TODO: make a Rule class for them.
  def rules
    @api_response['rules'] ? Array(@api_response['rules']['Rule']) : []
  end

  def full_url
    @api_response['fullUrl']
  end
  # We really want to call it like this, but for least-surprise, we'll also have
  # the more closely-matches-the-API name
  alias trophy_url full_url

  def thumb_url
    @api_response['thumbUrl']
  end
  # We really want to call it like this, but for least-surprise, we'll also have
  # the more closely-matches-the-API name
  alias trophy_thumb_url thumb_url

end
