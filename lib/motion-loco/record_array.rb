motion_require 'observable'

module Loco
  
  class RecordArray
    include Observable
    property :content
    property :item_class
    property :length
    property :belongs_to
    
    def <<(record)
      self.content << record
      self.length = self.content.length
      self
    end
    
    def addObjectsFromArray(objects)
      self.content.addObjectsFromArray(objects)
      self.length = self.content.length
      self
    end
    
    def initialize(properties={})
      super
      self.content = Array.new
      self.length = 0
      self
    end
    
    def load(type, data)
      self.item_class = type
      
      self.content.removeAllObjects
      data.each do |item_data|
        self.content.addObject(type.new(item_data))
      end
      self.length = self.content.length
      
      @loaded = true
      
      self
    end
    
    def loaded?
      @loaded
    end
    
    def method_missing(method, *args, &block)
      self.content.send(method, *args, &block)
    end
    
  end
  
end