%w{rubygems ostruct xmlrpc/client nokogiri open-uri feed_tools}.each { |f| require f }


require "io_tools/importer"
require "io_tools/helpers/rss_feed"
require "io_tools/helpers/xml_rpc"

module IoTools
  VERSION = '0.0.1'
  class ItemStruct < OpenStruct
     def to_json *_
       self.table.inject({}){|h,f| h[f.first] = f.last; h }.to_json
    end
  end
end