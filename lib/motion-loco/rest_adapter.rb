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
      type = record.class
      BW::HTTP.post("#{self.url}/#{type.to_s.underscore.pluralize}.json", { payload: record.serialize }) do |response|
        if response.ok?
          error = Pointer.new(:id)
          data = NSJSONSerialization.JSONObjectWithData(response.body, options:JSON_OPTIONS, error:error)
          load(type, record, data)
          block.call(record) if block.is_a? Proc
        else
          Loco.debug("Responded with #{response.status_code}")
          Loco.debug(response.error_message)
        end
      end
      record
    end
    
    def delete_record(record, &block)
      type = record.class
      BW::HTTP.delete("#{self.url}/#{type.to_s.underscore.pluralize}/#{record.id}.json") do |response|
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
      type = record.class
      BW::HTTP.get("#{self.url}/#{type.to_s.underscore.pluralize}/#{id}.json") do |response|
        if response.ok?
          error = Pointer.new(:id)
          data = NSJSONSerialization.JSONObjectWithData(response.body, options:JSON_OPTIONS, error:error)
          load(type, record, data)
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
          load(type, records, data)
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
          load(type, records, data)
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
          load(type, records, data)
          block.call(records) if block.is_a? Proc
        else
          Loco.debug("Responded with #{response.status_code}")
          Loco.debug(response.error_message)
        end
      end
      records
    end
    
    def update_record(record, &block)
      type = record.class
      BW::HTTP.put("#{self.url}/#{type.to_s.underscore.pluralize}/#{record.id}.json", { payload: record.serialize }) do |response|
        if response.ok?
          block.call(record) if block.is_a? Proc
        else
          Loco.debug("Responded with #{response.status_code}")
          Loco.debug(response.error_message)
        end
      end
      record
    end
    
    def serialize(record, options={})
      json = {}
      record.class.get_class_relationships.each do |relationship|
        if relationship[:belongs_to]
          key = "#{relationship[:belongs_to]}_id".to_sym
        elsif relationship[:has_many]
          key = "#{relationship[:has_many].to_s.singularize}_ids".to_sym
        end
        value = record.valueForKey(key)
        json[key] = value if value
      end
      super(record, options, json)
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
    
    Adapter.register_transform(:datetime, {
      serialize: lambda{|value|
        dateFormatter = NSDateFormatter.alloc.init
        dateFormatter.setTimeZone(NSTimeZone.timeZoneWithName('UTC'))
        dateFormatter.setDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
        dateFormatter.stringFromDate(value)
      },
      deserialize: lambda{|value|
        if value.is_a? NSDate
          value
        else
          dateFormatter = NSDateFormatter.alloc.init
          dateFormatter.setTimeZone(NSTimeZone.timeZoneWithName('UTC'))
          dateFormatter.setDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
          dateFormatter.dateFromString(value.to_s)
        end
      }
    })
    
  end
  
end