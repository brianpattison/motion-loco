module Loco
  
  class FixtureAdapter < Adapter
    JSON_OPTIONS = NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
    
    class RecordNotFound < StandardError
    end
    
    def find(record, id, &block)
      error = Pointer.new(:id)
      data = File.read(File.join(NSBundle.mainBundle.resourcePath, "fixtures", "#{record.class.to_s.underscore.pluralize}.json"))
      fixtures = NSJSONSerialization.JSONObjectWithData(data.to_data, options:JSON_OPTIONS, error:error)
      found = fixtures.find{|obj| obj[:id] == id }
      if found
        if block_given?
          yield id, found
        else
          found
        end
      else
        raise Loco::FixtureAdapter::RecordNotFound, "Record with the id `#{id}' could not be loaded."
      end
    end
    
    def find_all(type, records, &block)
      error = Pointer.new(:id)
      data = File.read(File.join(NSBundle.mainBundle.resourcePath, "fixtures", "#{type.to_s.underscore.pluralize}.json"))
      fixtures = NSJSONSerialization.JSONObjectWithData(data.to_data, options:JSON_OPTIONS, error:error)
      if block_given?
        yield fixtures
      else
        fixtures
      end
    end
    
  end
  
end