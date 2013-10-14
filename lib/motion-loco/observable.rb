module Loco
  
  module Observable
    
    def get(path)
      Loco.get(self, path)
    end
    
    def set(path, value)
      Loco.set(self, path, value)
    end
    
    module ClassMethods
      
      def property(property_name, type=nil)
        property_name = property_name.to_s
      end
      
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
  end
  
end