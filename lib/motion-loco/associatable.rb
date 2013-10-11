module Loco
  
  module Associatable
    
    module ClassMethods
      
      def belongs_to(model, options={})
        
      end
      
      def has_many(model, options={})
        
      end
      
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
  end
  
end