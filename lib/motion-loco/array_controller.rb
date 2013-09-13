motion_require 'controller'

module Loco
  
  class ArrayController < Controller
  
    def self.instance
      @instance ||= begin
        new(content: RecordArray.new)
      end
    end
    
  end
  
end