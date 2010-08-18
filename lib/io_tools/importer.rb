module IoTools
  module Importer

    def self.included klass
      klass.class_eval do
        attr_reader :params
        
        extend  ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods

      def collect *args, &block
        define_method :collection do
          @collection ||= block_given? ? instance_eval(&block) : send(args.first)
        end
      end

      def conform &block
        define_method :conform do |post|
          block.call(post, ItemStruct.new)
        end
      end
      
    end

    module InstanceMethods
      
      def initialize opts={}
        @params = opts
      end
      
      def conformed_collection
        @conformed_collection ||= collection.collect{ |post| conform(post) }
      end
      
      def import!
        conformed_collection
      end
      
    end
  end
end
