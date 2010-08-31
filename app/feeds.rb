require 'rss/2.0'
require 'open-uri'

module Feeds

  def Feeds.get_feeds
    feed_urls = [
      'http://feeds.feedburner.com/TechCrunch', 
      'http://www.reddit.com/new.rss', 
      'http://feeds2.feedburner.com/cyclingnews/news',
      'http://feeds.wired.com/wired/index?format=xml']
    feeds = Array.new
    for url in feed_urls
      puts('url = ' + url)
      open(url) do |http|
        response = http.read
        result = RSS::Parser.parse(response, false)
        feeds << result if result
      end
    end
    feeds
  end
  
end