module Loco
  
  module Persistable
    
    def destroy(&block)
      adapter = self.class.get_class_adapter
      unless self.new?
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
    
    def new?
      self.id.nil?
    end
    
    def save(&block)
      adapter = self.class.get_class_adapter
      if self.new?
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
      self.class.get_class_adapter.serialize(self, options)
    end
    
    module ClassMethods
      
      def adapter(adapter_class, *args)
        if adapter_class.is_a? String
          @adapter = adapter_class.constantize.new(*args)
        else
          @adapter = adapter_class.new(*args)
        end
      end
      
      def find(id=nil, &block)
        adapter = self.get_class_adapter
        if id.nil?
          # Return all records
          records = RecordArray.new(item_class: self.class)
          adapter.find_all(self, records) do |records|
            block.call(records) if block.is_a? Proc
          end
        elsif id.is_a? Array
          # Return records with given ids
          records = RecordArray.new(item_class: self.class)
          id.each do |i|
            records << self.new(id: i)
          end
          adapter.find_many(self, records, id) do |records|
            block.call(records) if block.is_a? Proc
          end
        elsif id.is_a? Hash
          # Return records matching query
          records = RecordArray.new(item_class: self.class)
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