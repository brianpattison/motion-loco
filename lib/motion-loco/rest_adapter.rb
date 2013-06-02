module Loco
  
  class RESTAdapter < Adapter
    class RecordNotFound < StandardError
    end
    
    def create_record(record, &block)
      # POST "#{root_url}/#{type.to_s.underscore.pluralize}"
    end
    
    def find(record, id, &block)
      # GET "#{root_url}/#{type.to_s.underscore.pluralize}/#{id}"
      # 
      # if data
      #   record.load(id, data)
      #   yield record if block_given?
      #   record
      # else
      #   raise Loco::FixtureAdapter::RecordNotFound, "#{record.class} with the id `#{id}' could not be loaded."
      # end
    end
    
    def find_all(type, records, &block)
      # "#{root_url}/#{type.to_s.underscore.pluralize}"
      # 
      # records.load(type, data)
      # yield records if block_given?
      # records
    end
    
    def find_many(type, records, ids, &block)
      # "#{root_url}/#{type.to_s.underscore.pluralize}?ids[]="
      # 
      # records.load(type, data)
      # yield records if block_given?
      # records
    end
    
    def find_query(type, records, query, &block)
      # "#{root_url}/#{type.to_s.underscore.pluralize}?query=query"
      # 
      # records.load(type, data)
      # yield records if block_given?
      # records
    end
    
    def save_record(record, &block)
      # PUT "#{root_url}/#{type.to_s.underscore.pluralize}/#{record.id}"
    end
    
    def delete_record(record, &block)
      # DELETE "#{root_url}/#{type.to_s.underscore.pluralize}/#{record.id}" 
    end
    
  end
  
end