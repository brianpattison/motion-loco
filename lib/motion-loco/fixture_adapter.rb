module Loco
  
  class FixtureAdapter < Adapter
    JSON_OPTIONS = NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
    
    class RecordNotFound < StandardError
    end
    
    def create_record(record, &block)
      raise NoMethodError, "Loco::FixtureAdapter cannot create records."
    end
    
    def find(record, id, &block)
      type = record.class
      error = Pointer.new(:id)
      filename = File.join(NSBundle.mainBundle.resourcePath, "fixtures", "#{type.to_s.underscore.gsub('nskvo_notifying_', '').pluralize}.json")
      file = File.read(filename)
      data = NSJSONSerialization.JSONObjectWithData(file.to_data, options:JSON_OPTIONS, error:error).find{|obj| obj[:id] == id }
      if data
        load(type, record, data)
        block.call(record) if block.is_a? Proc
        record
      else
        raise Loco::FixtureAdapter::RecordNotFound, "#{type} with the id `#{id}' could not be loaded."
      end
    end
    
    def find_all(type, records, &block)
      error = Pointer.new(:id)
      file = File.read(File.join(NSBundle.mainBundle.resourcePath, "fixtures", "#{type.to_s.underscore.pluralize}.json"))
      data = NSJSONSerialization.JSONObjectWithData(file.to_data, options:JSON_OPTIONS, error:error)
      load(type, records, data)
      block.call(records) if block.is_a? Proc
      records
    end
    
    def find_many(type, records, ids, &block)
      error = Pointer.new(:id)
      file = File.read(File.join(NSBundle.mainBundle.resourcePath, "fixtures", "#{type.to_s.underscore.pluralize}.json"))
      data = NSJSONSerialization.JSONObjectWithData(file.to_data, options:JSON_OPTIONS, error:error).select{|obj| 
        ids.map(&:to_s).include?(obj[:id].to_s) 
      }
      load(type, records, data)
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
      load(type, records, data)
      block.call(records) if block.is_a? Proc
      records
    end
    
    def update_record(record, &block)
      raise NoMethodError, "Loco::FixtureAdapter cannot update records."
    end
    
    def delete_record(record, &block)
      raise NoMethodError, "Loco::FixtureAdapter cannot delete records."
    end
    
  end
  
end