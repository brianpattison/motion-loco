motion_require 'proc'

module Loco
  
  module Observable
    
    module ClassMethods
      
      def property(name, type=nil)
        
      end
      
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
  end
  
end