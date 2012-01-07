# This class encapsulates and partly interprets the response we receive
# from the Bunchball API when we make calls to it. This allows us to
# wrap some syntactic sugar around (.valid?, .payload, etc.) while still
# returning a single, uniform object from all API wrapper calls.
#
# The app developer will always receive a Response object back from the
# API call, whether it was valid or invalid, succeeded or failed. In
# theory. :)  From that point, in cases (like User.get_points_balance)
# where it's clear what value is most likely being sought, this value
# will be available as .payload.  The raw response will be stored in
# @api_response.

class Bunchball::Nitro::Response
  attr_accessor :api_response, :payload

  def initialize(response)
    @api_response = response
    # Default payload unless we get an explicit value set
    @payload = self.nitro
  end

  def errors
    # There should not BE an 'Error' key on a valid API call response, but if
    # there is, we sure don't want to return it as if there were.
    # TODO: Should this return nil or []?
    return [] if self.valid?
    nitro['Error'] rescue []
  end

  def method
    nitro['method']
  end

  # Convenience because I get tired of seeing "api_response['Nitro']" littered
  # about, and EVERYTHING the server sends back is parsed into the 'Nitro' key
  # by HTTParty.
  def nitro
    api_response['Nitro']
  end

  def res
    nitro['res']
  end

  def server
    nitro['server']
  end

  def valid?
    nitro['res'] && nitro['res'] == 'ok'
  end

end
