class Bunchball::Nitro::Challenge
  attr_accessor :api_response

  def initialize(response = {})
    @api_response = response
  end

  # Uncompleted challenges don't get a dateCompleted field at all from the API
  def completed?
    !! @api_response['dateCompleted']
  end

  def date_completed
    Time.at(@api_response['dateCompleted'].to_i) if self.completed?
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

  def trophy_url
    @api_response['fullUrl']
  end
  # We really want to call it like this, but for least-surprise, we'll also have
  # the more closely-matches-the-API name
  alias full_url trophy_url

  def trophy_thumb_url
    @api_response['thumbUrl']
  end
  # We really want to call it like this, but for least-surprise, we'll also have
  # the more closely-matches-the-API name
  alias thumb_url trophy_thumb_url

end
