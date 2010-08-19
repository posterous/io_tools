%w{rubygems sinatra haml}.each { |f| require f }

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../..', 'lib'))

@dir = File.expand_path(File.dirname(__FILE__))

require 'io_tools'

require dir + '/importers/posterous_feed_importer'
require dir + '/importers/posterous_api_importer'
require dir + '/importers/word_press_importer'

module IoTools
  class Server < Sinatra::Base

    set :views,  "#{@dir}/views"
    set :public, "#{@dir}/public"
    
    get "/" do
      haml :index
    end

    post '/import' do
      @klass    = params.delete('service').camelize.constantize
      @import   = klass.new(params)
      @posts    = @import.import!

      haml :import
    end

  end
end

