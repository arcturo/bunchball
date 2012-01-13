class Bunchball::Nitro::Level
  attr_accessor :api_response

  def initialize(response = {})
    @api_response = response
  end

  # def start_time
  #   Time.at(@api_response['startTime'].to_i) if @api_response['startTime']
  # end
  # 
  # def end_time
  #   Time.at(@api_response['endTime'].to_i) if @api_response['endTime']
  # end
  # 
  # def date_completed
  #   Time.at(@api_response['dateCompleted'].to_i) if self.completed?
  # end
  # 
  # def has_trophy?
  #   @api_response['fullUrl'] || @api_response['thumbUrl']
  # end

  def name
    @api_response['name']
  end

  # def point_award
  #   @api_response['pointAward'].to_i
  # end
  # 
  # def trophy_url
  #   @api_response['fullUrl']
  # end
  # # We really want to call it like this, but for least-surprise, we'll also have
  # # the more closely-matches-the-API name
  # alias full_url trophy_url
  # 
  # def trophy_thumb_url
  #   @api_response['thumbUrl']
  # end
  # # We really want to call it like this, but for least-surprise, we'll also have
  # # the more closely-matches-the-API name
  # alias thumb_url trophy_thumb_url

end
