require 'add_uniq_by_to_array'

module TwitterHelper
  
  RAILS_CACHE_KEY = 'twitter.tweets.recent'
  
  def build_recent_tweets_sidebar
    tweets = recent_tweets
    return if tweets.empty?
    sidebar do
      content_tag(:ul, :class => 'twitter') do
        tweets.map do |tweet|
          content_tag(:li, :class => 'tweet') do
            author  = link_to(tweet.from_user, "http://twitter.com/#{tweet.from_user}")
            content = auto_link(tweet.text, :html => { :target => 'twitter', :rel => 'nofollow' })
            image_tag(tweet.profile_image_url) + content_tag(:div, author) + content_tag(:div, content)
          end
        end.join(' ')
      end
    end
  end
  
  def recent_tweets(force = false)
    if force
      # clear instance-level and application-level caches:
      Rails.cache.delete RAILS_CACHE_KEY
      @recent_tweets = nil
    end
    @recent_tweets ||= begin
      yaml = Rails.cache.fetch RAILS_CACHE_KEY do
        (recent_tweets_by_daymash + recent_tweets_about_daymash).uniq_by(&:id).sort_by { |t|
          Time.parse(t.created_at)
        }.reverse.to_yaml
      end
      YAML.load(yaml)
    rescue Crack::ParseError, SocketError
      []
    end
  end
  
  def recent_tweets_by_daymash
    Twitter::Search.new.from('daymash').per_page(5).fetch.results || []
  end
  
  def recent_tweets_about_daymash
    Twitter::Search.new('daymash').per_page(5).fetch.results || []
  end
  
end
