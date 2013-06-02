module Loco
  
  class Adapter
    
    def create_record(record, &block)
      raise NoMethodError, "Loco::Adapter subclasses must implement #create_record(record, &block)."
    end
    
    def find(record, id, &block)
      raise NoMethodError, "Loco::Adapter subclasses must implement #find(record, id, &block)."
    end
    
    def find_all(type, records, &block)
      raise NoMethodError, "Loco::Adapter subclasses must implement #find_all(type, records, &block)."
    end
    
    def find_many(type, records, ids, &block)
      raise NoMethodError, "Loco::Adapter subclasses must implement #find_many(type, records, ids, &block)."
    end
    
    def find_query(type, records, params, &block)
      raise NoMethodError, "Loco::Adapter subclasses must implement #find_query(type, records, params, &block)."
    end
    
    def save_record(record, &block)
      raise NoMethodError, "Loco::Adapter subclasses must implement #save_record(record, &block)."
    end
    
    def delete_record(record, &block)
      raise NoMethodError, "Loco::Adapter subclasses must implement #delete_record(record, &block)."
    end
    
  end
  
end