motion_require 'observable'

module Loco
  
  class RecordArray
    include Observable
    property :content
    property :item_class
    
    def initialize(properties={})
      super
      self.content = Array.new
      self
    end
    
    def load(type, data)
      self.content.removeAllObjects
      data.each do |item_data|
        self.content.addObject(type.new(item_data))
      end
      self
    end
    
    def method_missing(method, *args, &block)
      self.content.send(method, *args, &block)
    end
    
  end
  
end