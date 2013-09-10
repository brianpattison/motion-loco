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
    
    def initialize(properties={})
      super
      initialize_relationships
      self
    end
    
    def initialize_relationships
      self.class.get_class_relationships.select{|relationship| relationship[:has_many] }.each do |relationship|
        has_many_class = relationship[:has_many].to_s.classify.constantize
        self.send("#{relationship[:has_many]}=", RecordArray.new(item_class: has_many_class, belongs_to: self))
        self.send("#{relationship[:has_many].to_s.singularize}_ids=", [])
        Loco.debug(self.comment_ids) if self.respond_to? :comment_ids
      end
    end
    
    def load(id, data)
      data.merge!({ id: id })
      self.set_properties(data)
      Loco.debug(self.comment_ids) if self.respond_to? :comment_ids
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
        attr_accessor "#{model}_id"
        
        define_method "#{model}" do |&block|
          belongs_to_class = model.to_s.classify.constantize
          record = instance_variable_get("@#{model}")
          if record
            block.call(record) if block.is_a? Proc
            record
          else
            belongs_to_id = self.send("#{model}_id")
            if belongs_to_id
              belongs_to_class.find(belongs_to_id) do |record|
                instance_variable_set("@#{model}", record)
                block.call(record) if block.is_a? Proc
              end
            else
              block.call(record) if block.is_a? Proc
              record
            end
          end
        end
        
        define_method "#{model}=" do |record|
          belongs_to_class = model.to_s.classify.constantize
          raise TypeError, "Expecting a #{belongs_to_class} as defined by #belongs_to :#{model}" unless record.is_a? belongs_to_class
          instance_variable_set("@#{model}", record)
          self.send("#{model}_id=", (record.nil? ? nil : record.id))
          record
        end
        
        relationships = get_class_relationships
        relationships << { belongs_to: model }
      end
      
      def has_many(model)
        attr_accessor model
        attr_accessor "#{model.to_s.singularize}_ids"
        
        define_method "#{model}" do |&block|
          has_many_class = model.to_s.singularize.classify.constantize
          
          records = instance_variable_get("@#{model}")
          if records
            block.call(records) if block.is_a? Proc
            records
          else
            has_many_ids = instance_variable_get("@#{model.to_s.singularize}_ids")
            if has_many_ids
              record_array = has_many_class.find(has_many_ids) do |records|
                records.belongs_to = self
                block.call(records) if block.is_a? Proc
              end
            else
              query = {}
              query["#{self.class.to_s.underscore.singularize}_id"] = self.id
              record_array = has_many_class.find(query) do |records|
                records.belongs_to = self
                block.call(records) if block.is_a? Proc
              end
            end
            record_array.belongs_to = self
            record_array
          end
        end
        
        define_method "#{model}=" do |records|
          has_many_class = model.to_s.singularize.classify.constantize
          
          if (records.is_a?(RecordArray) || records.is_a?(Array)) && (records.length == 0 || (records.length > 0 && records.first.class == has_many_class))
            unless records.is_a?(RecordArray)
              record_array = RecordArray.new(item_class: has_many_class, belongs_to: self)
              record_array.addObjectsFromArray(records)
              records = record_array
            end
          else
            raise TypeError, "Expecting a Loco::RecordArray of #{has_many_class} objects as defined by #has_many :#{model}"
          end
          
          instance_variable_set("@#{model}", records)
          instance_variable_set("@#{model.to_s.singularize}_ids", records.map(&:id))
          records
        end
        
        relationships = get_class_relationships
        relationships << { has_many: model }
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
    
  end
  
end