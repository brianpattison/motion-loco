module Loco
  
  module Associatable
    
    def initialize(properties={})
      super
      initialize_relationships
      self
    end
    
    def initialize_relationships
      self.class.get_class_relationships.select{|relationship| relationship[:has_many] }.each do |relationship|
        has_many_class = relationship[:class_name] ? relationship[:class_name].to_s.classify.constantize : relationship[:has_many].to_s.classify.constantize
        self.send("#{relationship[:has_many]}=", RecordArray.new(relationship: relationship, item_class: has_many_class, belongs_to: self))
        self.send("#{relationship[:has_many].to_s.singularize}_ids=", [])
      end
    end
    
    module ClassMethods
      
      def belongs_to(model, options={})
        attr_accessor model
        attr_accessor "#{model}_id"
        
        define_method "#{model}" do |&block|
          belongs_to_class = options[:class_name] ? options[:class_name].to_s.classify.constantize : model.to_s.classify.constantize
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
          belongs_to_class = options[:class_name] ? options[:class_name].to_s.classify.constantize : model.to_s.classify.constantize
          raise TypeError, "Expecting a #{belongs_to_class} as defined by #belongs_to :#{model}" unless record.is_a? belongs_to_class
          instance_variable_set("@#{model}", record)
          self.send("#{model}_id=", (record.nil? ? nil : record.id))
          record
        end
        
        camelized = model.to_s.camelize(:lower)
        if model.to_s != camelized
          alias_method camelized, model
          alias_method "#{camelized}=", "#{model}="
        end
        
        relationships = get_class_relationships
        relationships << { belongs_to: model, class_name: options[:class_name] }
      end
      
      def has_many(model, options={})
        attr_accessor model
        attr_accessor "#{model.to_s.singularize}_ids"
        
        define_method "#{model}" do |&block|
          has_many_class = options[:class_name] ? options[:class_name].to_s.classify.constantize : model.to_s.singularize.classify.constantize
          record_array = instance_variable_get("@#{model}")
          if record_array.is_loaded
            block.call(record_array) if block.is_a? Proc
            record_array
          else
            has_many_ids = instance_variable_get("@#{model.to_s.singularize}_ids")
            if has_many_ids
              array = has_many_class.find(has_many_ids) do |records|
                record_array.load(records)
                instance_variable_set("@#{model}", record_array)
                block.call(record_array) if block.is_a? Proc
              end
              record_array.load(array)
            else
              query = {}
              foreign_key = options[:foreign_key] ? options[:foreign_key] : "#{self.class.to_s.underscore.singularize}_id"
              query[foreign_key] = self.id
              array = has_many_class.find(query) do |records|
                record_array.load(records)
                instance_variable_set("@#{model}", record_array)
                block.call(record_array) if block.is_a? Proc
              end
              record_array.load(array)
            end
            instance_variable_set("@#{model}", record_array)
            record_array
          end
        end
        
        define_method "#{model}=" do |records|
          has_many_class = options[:class_name] ? options[:class_name].to_s.classify.constantize : model.to_s.singularize.classify.constantize
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
        
        camelized = model.to_s.camelize(:lower)
        if model.to_s != camelized
          alias_method camelized, model
          alias_method "#{camelized}=", "#{model}="
        end
        
        relationships = get_class_relationships
        relationships << { has_many: model, class_name: options[:class_name] }
      end
      
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
  end
  
end