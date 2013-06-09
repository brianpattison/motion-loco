motion_require 'observable'
motion_require 'record_array'

module Loco
  
  module Savable
    
    def destroy(&block)
      adapter = self.class.get_class_adapter
      unless self.id.nil?
        adapter.delete_record(self) do |record|
          block.call(record) if block.is_a? Proc
        end
      end
    end
    
    def load(id, data)
      data.merge!({ id: id })
      self.set_properties(data)
      self
    end
    
    def save(&block)
      adapter = self.class.get_class_adapter
      if self.id.nil?
        adapter.create_record(self) do |record|
          block.call(record) if block.is_a? Proc
        end
      else
        adapter.update_record(self) do |record|
          block.call(record) if block.is_a? Proc
        end
      end
    end
    
    def serialize(options={})
      json = {}
      properties = self.class.get_class_properties.clone
      
      unless options[:include_id] || options[:includeId]
        properties.delete(:id)
      end
      
      if options[:root] == false
        properties.each do |key|
          json[key.to_sym] = self.valueForKey(key)
        end
      else
        if options[:root].nil? || options[:root] == true
          root = self.class.to_s.underscore.to_sym
        else
          root = options[:root].to_sym
        end
        json[root] = {}
        properties.each do |key|
          json[root][key.to_sym] = self.valueForKey(key)
        end
      end
      json
    end
    
    module ClassMethods
      
      def adapter(adapter_class, *args)
        if adapter_class.is_a? String
          @adapter = adapter_class.split('::').inject(Object) {|mod, class_name| mod.const_get(class_name) }.new(*args)
        else
          @adapter = adapter_class.new(*args)
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
      alias_method :all, :find
      alias_method :where, :find
      
      def get_class_adapter
        @adapter ||= Adapter.new
      end
      
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
  end
  
end