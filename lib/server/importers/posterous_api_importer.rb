$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'io_tools'
require 'xmlsimple'

class PosterousApiImporter
  include IoTools::Importer
  
  PER_PAGE_LIMIT = 50
  
  collect :paginated_results
  
  conform do |incoming, conformed|
    conformed.title         = incoming['title']
    conformed.body          = incoming['body']
    conformed.display_date  = incoming['display_date']
    conformed.author        = incoming['author']
    conformed.comments      = self.extract_comments(incoming['comment'])
    conformed
  end
  
  def self.extract_comments comments
    return [] if comments.nil?
    if comments.is_a? Array
      comments.inject(IoTools::ItemStruct.new) do |comment,cmt|
        comment.body    = cmt['body']
        comment.author  = cmt['author']
        comment.date    = cmt['date']
        comment
      end
    else
      []
    end
  end

  def paginated_results
    items = [] 
    while current_items = items_for_current_page
      items += current_items
      self.current_page += 1
    end
    items
  end

  def url
    @url ||= URI.parse('http://posterous.com/api/readposts')
  end

  def items_for_current_page
    XmlSimple.xml_in( self.response_for_current_page, 'ForceArray' => false )['post']
  end

  def response_for_current_page
    Net::HTTP.new(url.host, url.port).start { |http| http.request(request) }.body
  end
  
  def request
    @username, @password = self.params.delete('username'), self.params.delete('password') unless @username.present?
    req = Net::HTTP::Get.new(url.path)
    req.basic_auth @username, @password   
    req.set_form_data self.params.merge('num_posts' => PER_PAGE_LIMIT, 'page' => current_page)
    req
  end
  
  def current_page
    @current_page ||= 1
  end
  
  def current_page=(num)
    @current_page = num
  end

end