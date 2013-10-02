motion_require 'observable'

module Loco
  
  class RecordArray
    include Observable
    property :belongs_to
    property :content
    property :is_loaded, :boolean
    property :item_class
    property :length, :integer
    property :relationship, :hash
    
    def <<(record)
      self.addObjectsFromArray([record])
    end
    
    def addObjectsFromArray(objects)
      objects.each do |object|
        belongs_to_name = self.belongs_to.class.to_s.underscore.gsub('nskvo_notifying_', '')
        object.send("#{belongs_to_name}=", self.belongs_to) if self.belongs_to && object.respond_to?(belongs_to_name)
      end
      self.content.addObjectsFromArray(objects)
      update_properties
      self
    end
    
    def delete(object)
      result = self.content.delete(object)
      update_properties
      result
    end
    
    def initialize(properties={})
      super
      self.content = Array.new
      self.length = 0
      self
    end
    
    def load(type, data=nil)
      if type.is_a? RecordArray
        self.content = type.content
      else
        self.item_class = type      
        self.content.removeAllObjects
        data.each do |item_data|
          self.content.addObject(type.new(item_data))
        end
      end
      
      update_properties
      self.is_loaded = true
      
      self
    end
    
    def method_missing(method, *args, &block)
      self.content.send(method, *args, &block)
    end
    
  private
  
    def update_properties
      self.length = self.content.length
      if self.belongs_to
        self.belongs_to.send("#{self.relationship[:has_many].to_s.singularize}_ids=", self.content.map(&:id))
      end
    end
    
  end
  
end