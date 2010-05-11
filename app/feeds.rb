require 'rss/2.0'
require 'open-uri'

module Feeds

  def Feeds.get_feeds
    feed_urls = {'techcrunch' => 'http://feeds.feedburner.com/TechCrunch', 'digg' => 'http://feeds.digg.com/digg/popular.rss', 'cycling news' => 'http://feeds2.feedburner.com/cyclingnews/news'}
    feeds = {}
    feed_urls.each do |name, url|
      open(url) do |http|
        response = http.read
        result = RSS::Parser.parse(response, false)
        feeds[name] = result.items
      end
    end
    feeds
  end
  
end