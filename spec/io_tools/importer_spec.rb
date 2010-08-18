require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IoTools::Importer do
  describe "#new" do
        
    describe "with an import url" do
      before(:each) do
        @import = Import.new(:import_url => 'http://sweetness.com')
      end
      it "should set the :import_url" do
        @import.params[:import_url].should == 'http://sweetness.com'
      end
    end  
  end
  
  describe "#conform" do
    before(:each) do
      @import     = Import.new(:import_url => 'http://sweetness.com')
      @hash       = ENTRY_HASH
      @conformed  = @import.conform(@hash)
    end
    
    describe "conform hash keys" do
       ENTRY_HASH.each do |k,v|
        it "should set :#{k} to #{v}" do
          @conformed.send(k).should == v
        end
      end
    end
  end
  
  describe "#collection" do
    before(:each) do
      @import = Import.new(:import_url => 'http://sweetness.com')
    end
    
    it "should be an Array" do
      @import.collection.should be_an Array
    end    
    
    it "should contain the hashes" do
      @import.collection.each{|e| e.should be_a Hash }
    end
    
  end
  
  describe "#conformed_collection" do
    before(:each) do
      @import = Import.new(:import_url => 'http://sweetness.com')
    end
    
    it "should be an Array" do
      @import.conformed_collection.should be_an Array
    end    
    
    it "should contain the conformed structs" do
      @import.conformed_collection.each{|e| e.should be_a IoTools::ItemStruct }
    end
    
  end
  
end
