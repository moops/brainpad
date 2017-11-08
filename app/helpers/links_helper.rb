module LinksHelper
  # removes html tags from the description string
  def clean_feed_description(str)
    str.gsub(/<.*>/, '').gsub(/"/, '') if str
  end

  def link_text_from_feed(item, length = 55)
    return '' unless item.title
    item.title.length > length ? "#{item.title[0, length]}..." : item.title[0, length]
  end
end
