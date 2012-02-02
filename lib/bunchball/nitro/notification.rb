class Bunchball::Nitro::NotificationStyle
  attr_accessor :html, :name
  def initialize(response = {})
    @html = response['html']
    @name = response['name']
  end
end

# This one differs from some of the other wrapper classes (like Challenge) in
# that we actually have to track matched sets of information from the Response
# object. So we have to interact more with the Response object that we're going
# to get in our initializer, instead of expecting it to be a hash as we do in
# the Challenge and Rule classes.
class Bunchball::Nitro::Notification
  attr_accessor :api_response, :style

  def initialize(raw_notification = {}, raw_notification_style = {})
    raise "Need a valid Hash object (it's a #{raw_notification.class})" unless raw_notification.is_a? Hash
    @api_response = raw_notification.merge(:_notification_style => raw_notification_style)
    @style = Bunchball::Nitro::NotificationStyle.new(raw_notification_style)
  end

  def action
    @api_response['action']
  end

  def balance
    @api_response['balance'].to_i
  end

  def challenge
    @api_response['challenge']
  end

  def do_share
    @api_response['doShare']
  end

  def has_trophy?
    @api_response['challengeTrophyFullUrl'] || @api_response['challengeTrophyThumbUrl']
  end

  def lifetime_balance
    @api_response['lifetimeBalance'].to_i
  end

  def name
    @api_response['name']
  end

  def newsfeed
    @api_response['newsfeed']
  end

  def notification_settings
    @api_response['notificationSettings']
  end
  # We really want to call it like this, but for least-surprise, we'll also have
  # the more closely-matches-the-API name
  alias settings notification_settings

  def point_category
    @api_response['pointCategory']
  end

  def point_category_icon_url
    @api_response['pointCategoryIconUrl']
  end

  def point_category_limit
    @api_response['pointCategoryLimit'].to_i
  end

  def point_category_short
    @api_response['pointCategoryShort']
  end

  def points
    @api_response['points'].to_i
  end

  def style_name
    @api_response['styleName']
  end

  def timestamp
    Time.at(@api_response['timestamp'].to_i) if @api_response['timestamp']
  end

  def trophy_url
    @api_response['challengeTrophyFullUrl']
  end
  # We really want to call it like this, but for least-surprise, we'll also have
  # the more closely-matches-the-API name
  alias full_url trophy_url

  def trophy_thumb_url
    @api_response['challengeTrophyThumbUrl']
  end
  # We really want to call it like this, but for least-surprise, we'll also have
  # the more closely-matches-the-API name
  alias thumb_url trophy_thumb_url

  def updated
    Time.at(@api_response['updated'].to_i) if @api_response['updated']
  end

  def user
    Bunchball::Nitro::User.new(@api_response['userId'])
  end

  def user_id
    @api_response['userId']
  end

  def value
    @api_response['value'].to_i
  end

  def version
    @api_response['version'].to_i
  end
end
