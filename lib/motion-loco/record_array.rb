motion_require 'observable'

module Loco
  
  class RecordArray
    include Observable
    property :content
    property :item_class
    property :belongs_to
    
    def <<(record)
      self.content << record
    end
    
    def addObjectsFromArray(objects)
      self.content.addObjectsFromArray(objects)
    end
    
    def initialize(properties={})
      super
      self.content = Array.new
      self
    end
    
    def load(type, data)
      self.item_class = type
      
      self.content.removeAllObjects
      data.each do |item_data|
        self.content.addObject(type.new(item_data))
      end
      
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