motion_require 'observable'

module Loco
  
  class RecordArray < Array
    include Observable
    
    def did_load
      # Override to perform actions after loading data
    end
    alias_method :didLoad, :did_load
    
    def load(type, data)
      self.removeAllObjects
      data.each do |item_data|
        self.addObject(type.new(item_data))
      end
      self.did_load
      self
    end
    
    def initialize(properties={})
      self.init
      self
    end
    
  end
  
end