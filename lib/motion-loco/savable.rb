motion_require 'observable'
motion_require 'record_array'

module Loco
  
  module Savable
    
    def did_load
      # Override to perform actions after loading data
    end
    alias_method :didLoad, :did_load
    
    def load(id, data)
      data.merge!({ id: id })
      self.set_properties(data)
      self.did_load
      self
    end
    
    module ClassMethods
      
      def adapter(adapter_class)
        if adapter_class.is_a? String
          @adapter = adapter_class.split('::').inject(Object) {|mod, class_name| mod.const_get(class_name) }.new
        else
          @adapter = adapter_class.new
        end
      end
      
      def find(id=nil, &block)
        adapter = self.get_class_adapter
        if id.nil?
          # Return all records
          records = RecordArray.new
          adapter.find_all(self, records) do |records|
            block.call(records) if block.is_a? Proc
          end
        elsif id.is_a? Array
          # Return records with given ids
          records = RecordArray.new
          adapter.find_many(self, records, id) do |records|
            block.call(records) if block.is_a? Proc
          end
        elsif id.is_a? Hash
          # Return records matching query
          records = RecordArray.new
          adapter.find_query(self, records, id) do |records|
            block.call(records) if block.is_a? Proc
          end
        else
          record = self.new(id: id)
          adapter.find(record, id) do |record|
            block.call(record) if block.is_a? Proc
          end
        end
      end
      
      def get_class_adapter
        @adapter ||= Adapter.new
      end
      
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
  end
  
end