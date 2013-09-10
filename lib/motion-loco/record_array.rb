motion_require 'observable'

module Loco
  
  class RecordArray
    include Observable
    property :content
    property :item_class
    property :belongs_to
    
    def <<(record)
      self.content << record
      if self.belongs_to
        self.belongs_to.send("#{self.item_class.to_s.underscore}_ids") << record.id
      end
    end
    
    def addObjectsFromArray(objects)
      self.content.addObjectsFromArray(objects)
      if self.belongs_to
        self.belongs_to.send("#{self.item_class.to_s.underscore}_ids=") << self.content.map(&:id)
      end
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
      
      if self.belongs_to
        self.belongs_to.send("#{type.to_s.underscore}_ids=", self.content.map(&:id))
      end
      
      self
    end
    
    def method_missing(method, *args, &block)
      self.content.send(method, *args, &block)
    end
    
  end
  
end