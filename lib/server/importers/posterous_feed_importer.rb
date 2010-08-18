
class PosterousFeedImporter
  include IoTools::Importer
  include IoTools::Helpers::RssFeed

  MAX_PAGES     = 2
  FEED_SELECTOR = 'link[type="application/rss+xml"]'

  collect :paginated_feed_items
  
  conform do |incoming, conformed|
    conformed.title         = incoming.title
    conformed.body          = incoming.description
    conformed.display_date  = incoming.published
    conformed
  end

  def paginated_feed_items
    items = []
    1.upto(MAX_PAGES) do |num|
      items += items_from_page(num)
    end
    items
  end

  def feed_url
    @feed_url ||= Nokogiri::HTML(open(params[:feed_url])).css(FEED_SELECTOR).first['href']
  end

  def url_for_page num
    puts "#{feed_url}?page=#{num}"
    "#{feed_url}?page=#{num}"
  end

  def items_from_page num
    feed_items_from(url_for_page(num))
  end

end

# wp = PosterousFeedImporter.new(:feed_url => 'http://twoism.posterous.com')
# p wp.import!
