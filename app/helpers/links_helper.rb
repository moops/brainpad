module LinksHelper

  # removes html tags from the description string
  def clean_feed_description(str)
    str.gsub(/<.*>/,'').gsub(/"/,'')
  end
end
