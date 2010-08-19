module IoTools
  module Helpers
    module XmlRpc
      
      def server
        @server ||= XMLRPC::Client.new2(api_url, nil, 300)
      end

      def rpc method, *args
        server.call("metaWeblog.#{method.to_s}", self.metaweblog_id, self.params['username'], self.params['password'], *args)
      end

      def recent_posts num
        rpc :getRecentPosts, num
      end
      
    end
  end
end
