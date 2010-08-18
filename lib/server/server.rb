%w{rubygems sinatra haml}.each { |f| require f }

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../..', 'lib'))

require 'io_tools'
dir = File.expand_path(File.dirname(__FILE__))

require dir+'/importers/posterous_feed_importer'
require dir+'/importers/posterous_api_importer'



module IoTools
  
  
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/views"
    set :public, "#{dir}/public"
    
    get "/" do
      haml :index
    end

    post '/import' do
      klass = params.delete('service').camelize.constantize
      @import = klass.new(params)
      @posts = @import.import!
      haml :import
    end

  end
end
