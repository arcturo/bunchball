class Bunchball::Nitro::Challenge
  attr_accessor :api_response

  def initialize(response = {})
    @api_response = response
  end

  def active?
    active_state = true   # Default state if no start/end time is specified
    if start_time
      active_state = active_state && (Time.now > start_time)
    end
    if end_time
      active_state = active_state && (Time.now < end_time)
    end
    active_state
  end

  def start_time
    Time.at(@api_response['startTime'].to_i) if @api_response['startTime']
  end

  def end_time
    Time.at(@api_response['endTime'].to_i) if @api_response['endTime']
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

  def point_award
    @api_response['pointAward'].to_i
  end

  def rules
    unless @rules
      # Make sure we return an enumerable for the rules applying to this challenge,
      # even if there are none.
      @rules = []
      if @api_response['rules']
        [@api_response['rules']['Rule']].flatten.compact.each do |rule|
          @rules << Bunchball::Nitro::Rule.new(rule)
        end
      end
    end
    @rules
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
