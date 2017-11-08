require 'rss/2.0'
require 'open-uri'

module Feeds
  def self.get
    feed_urls = [
      'http://www.atpworldtour.com/en/media/rss-feed/xml-feed',
      'http://feeds2.feedburner.com/cyclingnews/news',
      'http://feeds.feedburner.com/TechCrunch',
      'https://www.wired.com/feed/'
    ]
    feeds = []
    feed_urls.each do |url|
      Rails.logger.info("getting feed from #{url}")
      begin
        open(url) do |http|
          response = http.read
          result = RSS::Parser.parse(response, false)
          feeds << result if result
        end
      rescue StandardError => e
        Rails.logger.error("feed exception: #{e.message}")
      end
    end
    feeds
  end
end
