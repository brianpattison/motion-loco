motion_require 'observable'

module Loco
  
  class RecordArray < Array
    include Observable
    
    def load(type, data)
      self.removeAllObjects
      data.each do |item_data|
        self.addObject(type.new(item_data))
      end
      self
    end
    
    def initialize(properties={})
      self.init
      self
    end
    
  end
  
end