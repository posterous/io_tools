module IoTools
  module Helpers
    module RssFeed
      
      def feed_items_from url
        FeedTools::Feed.open(url).items
      end
      
    end
  end
end
