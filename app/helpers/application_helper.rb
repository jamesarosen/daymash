require 'add_uniq_by_to_array'

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def inline_button_to(button_text, path, method, options = {})
    klass = 'inline'
    klass << ' ' << options[:class] if options[:class].present?
    form_tag(path, :method => method, :class => klass) +
      content_tag(:button, :type => 'submit', :name => 'submit') do
        content_tag(:span, button_text)
      end +
      '</form>'
  end
  
  def site_nav_bar
    nav_bar(:site) do |nb|
      if signed_in?
        nb.nav_item :aggregate, user_aggregate_path(:user_id => :current)
        nb.nav_item :my_profile, user_path(:current)
        nb.nav_item :sign_out
      else
        nb.nav_item :sign_up, rpx_url(users_url)
        nb.nav_item :sign_in, rpx_url(sessions_url)
      end
    end
  end
  
  def jquery_include_location
    Object.const_defined?(:JQUERY_LOCATION) ? JQUERY_LOCATION : 'jquery-1.3.2.min'
  end
  
  def rpx_scripts
    return <<-EOS
<script type="text/javascript">
  var rpxJsHost = (("https:" == document.location.protocol) ? "https://" : "http://static.");
  document.write(unescape("%3Cscript src='" + rpxJsHost +
"rpxnow.com/js/lib/rpx.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
  RPXNOW.overlay = true;
  RPXNOW.language_preference = 'en';
</script>
EOS
  end
  
  def rpx_url(return_to)
    "https://daymash.rpxnow.com/openid/v2/signin?token_url=#{URI.encode return_to}"
  end
  
  def google_analytics_scripts
    return <<-EOS
<script type="text/javascript">
  var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
  document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
  try {
    var pageTracker = _gat._getTracker("UA-7255350-2");
    pageTracker._trackPageview();
  } catch(err) {}
</script>
EOS
  end
  
  TWITTER_SIDEBAR_CACHE_KEY = 'sidebar.twitter'
  
  # Generates a sidebar <ul> containing the last five tweets by
  # or about @daymash. Caches the sidebar for a while.
  def recent_tweets_sidebar
    tweets = fetch_recent_tweets
    return '' if tweets.empty?
    Rails.cache.fetch(TWITTER_SIDEBAR_CACHE_KEY, :expire_in => 1.hour) do
      content_tag(:aside, :class => 'sidebar') do
        content_tag(:ul, :class => 'twitter') do
          tweets.map do |tweet|
            content_tag(:li, :class => 'tweet') do
              content = auto_link(tweet.text, :html => { :target => 'twitter', :rel => 'nofollow' })
              image_tag(tweet.profile_image_url) + content_tag(:div, content)
            end
          end.join(' ')
        end
      end
    end
  end
  
  def fetch_recent_tweets
    begin
      by_daymash = Twitter::Search.new.from('daymash').per_page(5).fetch.results || []
      to_daymash = Twitter::Search.new('daymash').per_page(5).fetch.results || []
      (by_daymash + to_daymash).uniq_by(&:id).sort_by { |t| Time.parse(t.created_at) }.reverse[0..4]
    rescue Crack::ParseError, SocketError
      []
    end
  end
    
end
