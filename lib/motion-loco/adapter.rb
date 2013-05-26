module Loco
  
  class Adapter
    
    def create_record(record)
      raise NoMethodError, "Loco::Adapter subclasses must implement #create_record(record)."
    end
    
    def find(record, id)
      raise NoMethodError, "Loco::Adapter subclasses must implement #find(record, id)."
    end
    
    def find_all(type, records)
      raise NoMethodError, "Loco::Adapter subclasses must implement #find_all(type, records)."
    end
    
    def find_many(type, records, ids)
      raise NoMethodError, "Loco::Adapter subclasses must implement #find_many(type, records, ids)."
    end
    
    def find_query(type, records, params)
      raise NoMethodError, "Loco::Adapter subclasses must implement #find_query(type, records, params)."
    end
    
    def load(record, id, data)
      record.load(id, data)
    end
    
    def save_record(record)
      raise NoMethodError, "Loco::Adapter subclasses must implement #save_record(record)."
    end
    
    def delete_record(record)
      raise NoMethodError, "Loco::Adapter subclasses must implement #delete_record(record)."
    end
    
  end
  
end