module Loco
  
  class RESTAdapter < Adapter
    JSON_OPTIONS = NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
    
    class RecordNotFound < StandardError
    end
    
    def initialize(*args)
      self.url = args.first if args && args.first
      super
    end
    
    def create_record(record, &block)
      BW::HTTP.post("#{self.url}/#{record.class.to_s.underscore.pluralize}.json", { payload: record.serialize(root: true) }) do |response|
        if response.ok?
          error = Pointer.new(:id)
          data = NSJSONSerialization.JSONObjectWithData(response.body, options:JSON_OPTIONS, error:error)
          record.load(data[record.class.to_s.underscore][:id], transform_data(record.class, data[record.class.to_s.underscore]))
          block.call(record) if block.is_a? Proc
        else
          Loco.debug("Responded with #{response.status_code}")
          Loco.debug(response.error_message)
        end
      end
      record
    end
    
    def delete_record(record, &block)
      BW::HTTP.delete("#{self.url}/#{record.class.to_s.underscore.pluralize}/#{record.id}.json") do |response|
        if response.ok?
          block.call(record) if block.is_a? Proc
        else
          Loco.debug("Responded with #{response.status_code}")
          Loco.debug(response.error_message)
        end
      end
      record
    end
    
    def find(record, id, &block)
      BW::HTTP.get("#{self.url}/#{record.class.to_s.underscore.pluralize}/#{id}.json") do |response|
        if response.ok?
          error = Pointer.new(:id)
          data = NSJSONSerialization.JSONObjectWithData(response.body, options:JSON_OPTIONS, error:error)
          record.load(id, transform_data(record.class, data[record.class.to_s.underscore]))
          block.call(record) if block.is_a? Proc
        else
          Loco.debug("Responded with #{response.status_code}")
          Loco.debug(response.error_message)
        end
      end
      record
    end
    
    def find_all(type, records, &block)
      BW::HTTP.get("#{self.url}/#{type.to_s.underscore.pluralize}.json") do |response|
        if response.ok?
          error = Pointer.new(:id)
          data = NSJSONSerialization.JSONObjectWithData(response.body, options:JSON_OPTIONS, error:error)
          records.load(type, transform_data(type, data[type.to_s.underscore.pluralize]))
          block.call(records) if block.is_a? Proc
        else
          Loco.debug("Responded with #{response.status_code}")
          Loco.debug(response.error_message)
        end
      end
      records
    end
    
    def find_many(type, records, ids, &block)
      BW::HTTP.get("#{self.url}/#{type.to_s.underscore.pluralize}.json", { payload: { ids: ids } }) do |response|
        if response.ok?
          error = Pointer.new(:id)
          data = NSJSONSerialization.JSONObjectWithData(response.body, options:JSON_OPTIONS, error:error)
          records.load(type, transform_data(type, data[type.to_s.underscore.pluralize]))
          block.call(records) if block.is_a? Proc
        else
          Loco.debug("Responded with #{response.status_code}")
          Loco.debug(response.error_message)
        end
      end
      records
    end
    
    def find_query(type, records, query, &block)
      BW::HTTP.get("#{self.url}/#{type.to_s.underscore.pluralize}.json", { payload: { query: query } }) do |response|
        if response.ok?
          error = Pointer.new(:id)
          data = NSJSONSerialization.JSONObjectWithData(response.body, options:JSON_OPTIONS, error:error)
          records.load(type, transform_data(type, data[type.to_s.underscore.pluralize]))
          block.call(records) if block.is_a? Proc
        else
          Loco.debug("Responded with #{response.status_code}")
          Loco.debug(response.error_message)
        end
      end
      records
    end
    
    def update_record(record, &block)
      BW::HTTP.put("#{self.url}/#{record.class.to_s.underscore.pluralize}/#{record.id}.json", { payload: record.serialize(root: true) }) do |response|
        if response.ok?
          block.call(record) if block.is_a? Proc
        else
          Loco.debug("Responded with #{response.status_code}")
          Loco.debug(response.error_message)
        end
      end
      record
    end
    
    def url
      unless @url.nil?
        @url
      else
        raise ArgumentError, "Loco::RESTAdapter needs a base URL when using in a model. Ex. `adapter 'Loco::RESTAdapter', 'http://mydomain.com'`"
      end
    end
    
    def url=(url)
      url.slice!(-1) if url.slice(-1) == '/'
      @url = url
    end
    
  end
  
end