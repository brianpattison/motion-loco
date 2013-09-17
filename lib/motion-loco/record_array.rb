motion_require 'observable'

module Loco
  
  class RecordArray
    include Observable
    property :belongs_to
    property :content
    property :is_loaded, :string
    property :item_class
    property :length, :integer
    
    def <<(record)
      self.content << record
      update_properties
      self
    end
    
    def addObjectsFromArray(objects)
      self.content.addObjectsFromArray(objects)
      update_properties
      self
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
        self.belongs_to.send("#{self.item_class.to_s.underscore.singularize}_ids=", self.content.map(&:id))
      end
    end
    
  end
  
end