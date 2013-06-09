motion_require 'observable'
motion_require 'record_array'

module Loco
  
  class Model
    include Observable
    property :id, :integer
    
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
      self.update_attributes(data)
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
      properties = self.class.get_class_properties.select{|prop| prop[:type] }
      transforms = self.class.get_class_adapter.class.get_transforms
      
      unless options[:include_id] || options[:includeId]
        properties.delete(:id)
      end
      
      properties.each do |property|
        key = property[:name].to_sym
        transform = transforms[property[:type]]
        if transform
          json[key] = transform[:serialize].call(self.valueForKey(key))
        else
          json[key] = self.valueForKey(key)
        end
      end
      
      if options[:root] != false
        if options[:root].nil? || options[:root] == true
          root = self.class.to_s.underscore.to_sym
        else
          root = options[:root].to_sym
        end
        temp = {}
        temp[root] = json
        json = temp
      end
      json
    end
    
    class << self
      
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
    
  end
  
end