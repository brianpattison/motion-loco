motion_require 'observable'
motion_require 'record_array'

module Loco
  
  class Model
    include Observable
    property :id, :integer
    
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
      self.update_attributes(data)
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
      json = {}
      properties = self.class.get_class_properties.select{|prop| 
        if prop[:type]
          if prop[:name] == :id
            options[:include_id] || options[:includeId]
          else
            true
          end
        end
      }
      transforms = self.class.get_class_adapter.class.get_transforms
      
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
          @adapter = adapter_class.constantize.new(*args)
        else
          @adapter = adapter_class.new(*args)
        end
      end
      
      def belongs_to(model)
        attr_accessor model
        property "#{model}_id", :integer
        
        belongs_to_class = model.to_s.classify.constantize
        
        define_method "#{model}" do |&block|
          record = instance_variable_get("@#{model}")
          if record
            block.call(record) if block.is_a? Proc
            record
          elsif belongs_to_id = self.send("#{model}_id")
            belongs_to_class.find(belongs_to_id) do |record|
              instance_variable_set("@#{model}", record)
              block.call(record) if block.is_a? Proc
            end
          else
            block.call(record) if block.is_a? Proc
            record
          end
        end
        
        define_method "#{model}=" do |record|
          raise TypeError, "Expecting a #{belongs_to_class} as defined by #belongs_to :#{model}" unless record.is_a? belongs_to_class
          self.send("#{model}_id=", (record.nil? ? nil : record.id))
          instance_variable_set("@#{model}", record)
          record
        end
      end
      
      def has_many(model)
        attr_accessor model
        property "#{model.to_s.singularize}_ids", :array
        
        has_many_class = model.to_s.singularize.classify.constantize
        
        define_method "#{model}" do |&block|
          records = instance_variable_get("@#{model}")
          if records
            block.call(records) if block.is_a? Proc
            records
          elsif has_many_ids = self.send("#{model.to_s.singularize}_ids")
            has_many_class.find(has_many_ids) do |records|
              block.call(records) if block.is_a? Proc
            end
          else
            records = RecordArray.new
            block.call(records) if block.is_a? Proc
            records
          end
        end
        
        define_method "#{model}=" do |records|
          if (records.is_a?(RecordArray) || records.is_a?(Array)) && (records.length == 0 || (records.length > 0 && records.first.class == has_many_class))
            unless records.is_a?(RecordArray)
              record_array = RecordArray.new
              record_array.addObjectsFromArray(records)
              records = record_array
            end
          else
            raise TypeError, "Expecting a Loco::RecordArray of #{has_many_class} objects as defined by #has_many :#{model}"
          end
          
          self.send("#{model.to_s.singularize}_ids=", records.map(&:id))
          instance_variable_set("@#{model}", records)
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