module Loco
  
  class RESTAdapter < Adapter
    JSON_OPTIONS = NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
    
    class RecordNotFound < StandardError
    end
    
    def create_record(record, &block)
      # POST "#{root_url}/#{type.to_s.underscore.pluralize}"
    end
    
    def find(record, id, &block)
      BW::HTTP.get("http://localhost:3000/#{record.class.to_s.underscore.pluralize}/#{id}.json") do |response|
        if response.ok?
          error = Pointer.new(:id)
          data = NSJSONSerialization.JSONObjectWithData(response.body, options:JSON_OPTIONS, error:error)
          record.load(id, data[record.class.to_s.underscore])
          block.call(record) if block.is_a? Proc
        else
          Loco.debug("Responded with #{response.status_code}")
          Loco.debug(response.error_message)
        end
      end
      record
    end
    
    def find_all(type, records, &block)
      BW::HTTP.get("http://localhost:3000/#{type.to_s.underscore.pluralize}.json") do |response|
        if response.ok?
          error = Pointer.new(:id)
          data = NSJSONSerialization.JSONObjectWithData(response.body, options:JSON_OPTIONS, error:error)
          records.load(type, data[type.to_s.underscore.pluralize])
          block.call(records) if block.is_a? Proc
        else
          Loco.debug("Responded with #{response.status_code}")
          Loco.debug(response.error_message)
        end
      end
      records
    end
    
    def find_many(type, records, ids, &block)
      BW::HTTP.get("http://localhost:3000/#{type.to_s.underscore.pluralize}.json", { payload: { ids: ids } }) do |response|
        if response.ok?
          error = Pointer.new(:id)
          data = NSJSONSerialization.JSONObjectWithData(response.body, options:JSON_OPTIONS, error:error)
          records.load(type, data[type.to_s.underscore.pluralize])
          block.call(records) if block.is_a? Proc
        else
          Loco.debug("Responded with #{response.status_code}")
          Loco.debug(response.error_message)
        end
      end
      records
    end
    
    def find_query(type, records, query, &block)
      BW::HTTP.get("http://localhost:3000/#{type.to_s.underscore.pluralize}.json", { payload: { query: query } }) do |response|
        if response.ok?
          error = Pointer.new(:id)
          data = NSJSONSerialization.JSONObjectWithData(response.body, options:JSON_OPTIONS, error:error)
          records.load(type, data[type.to_s.underscore.pluralize])
          block.call(records) if block.is_a? Proc
        else
          Loco.debug("Responded with #{response.status_code}")
          Loco.debug(response.error_message)
        end
      end
      records
    end
    
    def save_record(record, &block)
      # PUT "#{root_url}/#{type.to_s.underscore.pluralize}/#{record.id}"
    end
    
    def delete_record(record, &block)
      # DELETE "#{root_url}/#{type.to_s.underscore.pluralize}/#{record.id}" 
    end
    
  end
  
end