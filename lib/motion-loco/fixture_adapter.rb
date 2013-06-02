module Loco
  
  class FixtureAdapter < Adapter
    JSON_OPTIONS = NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
    
    class RecordNotFound < StandardError
    end
    
    def create_record(record, &block)
      raise NoMethodError, "Loco::FixtureAdapter cannot create records."
    end
    
    def find(record, id, &block)
      error = Pointer.new(:id)
      file = File.read(File.join(NSBundle.mainBundle.resourcePath, "fixtures", "#{record.class.to_s.underscore.pluralize}.json"))
      data = NSJSONSerialization.JSONObjectWithData(file.to_data, options:JSON_OPTIONS, error:error).find{|obj| obj[:id] == id }
      if data
        record.load(id, data)
        block.call(record) if block.is_a? Proc
        record
      else
        raise Loco::FixtureAdapter::RecordNotFound, "#{record.class} with the id `#{id}' could not be loaded."
      end
    end
    
    def find_all(type, records, &block)
      error = Pointer.new(:id)
      file = File.read(File.join(NSBundle.mainBundle.resourcePath, "fixtures", "#{type.to_s.underscore.pluralize}.json"))
      data = NSJSONSerialization.JSONObjectWithData(file.to_data, options:JSON_OPTIONS, error:error)
      records.load(type, data)
      block.call(records) if block.is_a? Proc
      records
    end
    
    def find_many(type, records, ids, &block)
      error = Pointer.new(:id)
      file = File.read(File.join(NSBundle.mainBundle.resourcePath, "fixtures", "#{type.to_s.underscore.pluralize}.json"))
      data = NSJSONSerialization.JSONObjectWithData(file.to_data, options:JSON_OPTIONS, error:error).select{|obj| 
        ids.map(&:to_s).include?(obj[:id].to_s) 
      }
      records.load(type, data)
      block.call(records) if block.is_a? Proc
      records
    end
    
    def find_query(type, records, query, &block)
      error = Pointer.new(:id)
      file = File.read(File.join(NSBundle.mainBundle.resourcePath, "fixtures", "#{type.to_s.underscore.pluralize}.json"))
      data = NSJSONSerialization.JSONObjectWithData(file.to_data, options:JSON_OPTIONS, error:error).select{|obj| 
        match = true
        query.each do |key, value|
          match = false if obj[key.to_sym] != value
        end
        match
      }
      records.load(type, data)
      block.call(records) if block.is_a? Proc
      records
    end
    
    def save_record(record, &block)
      raise NoMethodError, "Loco::FixtureAdapter cannot save records."
    end
    
    def delete_record(record, &block)
      raise NoMethodError, "Loco::FixtureAdapter cannot delete records."
    end
    
  end
  
end