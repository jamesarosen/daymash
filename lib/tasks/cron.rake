namespace :db do
  namespace :calendars do
    desc 'Permanently remove calendars deleted more than one day ago'
    task :delete_old => :environment do
      Calendar::Archive.delete_all(["deleted_at < ?", 1.day.ago]).tap do |num_rows|
        Rails.logger.info("Permanently removed #{num_rows} deleted calendars.")
      end
    end
  end
  namespace :credentials do
    desc 'Permanently remove credentials deleted more than one day ago'
    task :delete_old => :environment do
      Credential::Archive.delete_all(["deleted_at < ?", 1.day.ago]).tap do |num_rows|
        Rails.logger.info("Permanently removed #{num_rows} deleted credentials.")
      end
    end
  end
end

namespace :twitter do
  desc 'load recent tweets by and about DayMash into Rails.cache'
  task :cache_recent_tweets => :environment do
    o = Object.new.tap { |o| o.extend TwitterHelper }
    o.recent_tweets(true) # force recache of recent tweets
  end
end

desc 'The cron task is run daily by Heroku'
task :cron => ['db:calendars:delete_old', 'db:credentials:delete_old', 'twitter:cache_recent_tweets']
