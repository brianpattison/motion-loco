motion_require 'observable'
motion_require 'record_array'

module Loco
  
  module Savable
    
    def did_load
      # Override to perform actions after loading data
    end
    alias_method :didLoad, :did_load
    
    def load(id, data, &block)
      data.merge!({ id: id })
      self.set_properties(data)
      self.did_load
      yield self if block_given?
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
        if id.nil?
          # Return all records
          records = RecordArray.new
          adapter = self.get_class_adapter
          adapter.find_all(self, records) do |data|
            records.load(self, data) do |loaded_records|
              yield loaded_records if block_given?
            end
          end
          records
        elsif id.is_a? Array
          # Return records with given ids
          records = RecordArray.new
          adapter = self.get_class_adapter
          adapter.find_many(self, records, id) do |data|
            records.load(self, data) do |loaded_records|
              yield loaded_records if block_given?
            end
          end
          records
        elsif id.is_a? Hash
          # Return records matching query
          records = RecordArray.new
          adapter = self.get_class_adapter
          adapter.find_query(self, records, id) do |data|
            records.load(self, data) do |loaded_records|
              yield loaded_records if block_given?
            end
          end
          records
        else
          record = self.new(id: id)
          adapter = self.get_class_adapter
          adapter.find(record, id) do |id, data|
            record.load(id, data) do |loaded_record|
              yield record if block_given?
            end
          end
          record
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