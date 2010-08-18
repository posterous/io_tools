%w{open-uri nokogiri xmlrpc/client}.each { |f| require f }

class WordPressImporter
  include IoTools::Importer
  include IoTools::Helpers::XmlRpc

  RSD_SELECTOR          = 'link[rel=EditURI]'
  METAWEB_SELECTOR      = 'api[name=MetaWeblog]'
  MAX_POSTS_TO_REQUEST  = 20

  collect do
    recent_posts MAX_POSTS_TO_REQUEST
  end
  
  conform do 
    set :title,         entry['title']
    set :body,          entry['description']
    set :display_date,  entry['dateCreated'].to_time.utc
    set :tags,          entry['mt_keywords'].split(",")
  end
  
  # Methods below are helpers for detecting RSD for the
  # XML-RPC protocol.
  def scan_for_url
    rsd_doc.css( METAWEB_SELECTOR ).first['apilink']
  end
  
  def site_doc
    @site_doc ||= Nokogiri::HTML(html)
  end  
  
  def html
    @html ||= open self.import_url
  end
  
  def rsd_url
    @rsd_url ||= scan_for_rsd
  end
  
  def scan_for_rsd
    site_doc.css( RSD_SELECTOR ).first['href']
  end
  
  def scan_for_id
    rsd_doc.css( METAWEB_SELECTOR ).first['blogid']
  end
  
  def rsd_doc
    @rsd_doc ||= Nokogiri::HTML(rsd_html)
  end
  
  def rsd_html
    @rsd_html ||= open(rsd_url)
  end
  
  def metaweblog_id
    @metaweblog_id ||= scan_for_id
  end
  
  def api_url
    @api_url ||= scan_for_url
  end
  
end
