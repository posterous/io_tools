$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'io_tools'
require 'spec'
require 'spec/autorun'
require 'mocha'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

ENTRY_HASH  = {:title => "Sweet", :body => "An awesome post!"}

class Import
  include IoTools::Importer
  
  conform do |incoming,conformed|
    conformed.title = incoming[:title]
    conformed.body  = incoming[:body]
    conformed
  end 
  
  collect do
    [ENTRY_HASH,ENTRY_HASH]
  end
    
end
