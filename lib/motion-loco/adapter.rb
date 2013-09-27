motion_require 'convenience_methods'

module Loco
  
  class Adapter
    
    def create_record(record, &block)
      raise NoMethodError, "Loco::Adapter subclasses must implement #create_record(record, &block)."
    end
    
    def delete_record(record, &block)
      raise NoMethodError, "Loco::Adapter subclasses must implement #delete_record(record, &block)."
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
    
    def update_record(record, &block)
      raise NoMethodError, "Loco::Adapter subclasses must implement #update_record(record, &block)."
    end
    
    def serialize(record, options={}, json={})
      properties = record.class.get_class_properties.select{|prop| 
        if prop[:type]
          if prop[:name] == :id
            options[:include_id] || options[:includeId]
          else
            true
          end
        end
      }
      
      transforms = self.class.get_transforms
      
      properties.each do |property|
        key = property[:name].to_sym
        transform = transforms[property[:type]]
        if transform
          json[key] = transform[:serialize].call(record.valueForKey(key))
        else
          json[key] = record.valueForKey(key)
        end
      end
      
      if options[:root] != false
        if options[:root].nil? || options[:root] == true
          root = record.class.to_s.underscore.to_sym
        else
          root = options[:root].to_sym
        end
        temp = {}
        temp[root] = json
        json = temp
      end
      json
    end
    
    class << self
      
      def get_transforms
        if @transforms.nil?
          @transforms = {}
          if self.superclass.respond_to? :get_transforms
            @transforms.merge!(self.superclass.get_transforms)
          end
        end
        @transforms
      end
      
      def register_transform(name, transforms={})
        @transforms = get_transforms
        @transforms[name.to_sym] = transforms
      end
      alias_method :registerTransform, :register_transform
      
    end
    
  private
    
    def load(type, records, data)
      if records.is_a? RecordArray
        if data.is_a? Hash
          data = data[type.to_s.underscore.pluralize]
        end
        records.load(type, transform_data(type, data))
      else
        if data.is_a?(Hash) && data.has_key?(type.to_s.underscore)
          data = data[type.to_s.underscore] 
        end
        records.load(data.valueForKey(:id), transform_data(type, data))
      end
    end
    
    def transform_data_item(type, data)
      json = {}
      transforms = self.class.get_transforms
      
      type.get_class_properties.each do |property|
        key = property[:name].to_sym
        transform = transforms[property[:type]]
        if transform
          json[key] = transform[:deserialize].call(data.valueForKey(key))
        else
          json[key] = data.valueForKey(key)
        end
      end
      
      type.get_class_relationships.each do |relationship|
        if relationship[:belongs_to]
          key = "#{relationship[:belongs_to]}_id".to_sym
        elsif relationship[:has_many]
          key = "#{relationship[:has_many].to_s.singularize}_ids".to_sym
        end
        json[key] = data.valueForKey(key)
      end
      
      json
    end
    
    def transform_data(type, data)
      if data.is_a? Array
        json = []
        data.each do |data_item|
          json << transform_data_item(type, data_item)
        end
        json
      else
        transform_data_item(type, data)
      end
    end
  end
  
  Adapter.register_transform(:array, {
    serialize: lambda{|value|
      value.to_a
    },
    deserialize: lambda{|value|
      value.to_a
    }
  })
  
  Adapter.register_transform(:date, {
    serialize: lambda{|value|
      dateFormatter = NSDateFormatter.alloc.init
      dateFormatter.setDateFormat('yyyy-MM-dd')
      dateFormatter.stringFromDate(value)
    },
    deserialize: lambda{|value|
      if value.is_a? NSDate
        value
      else
        dateFormatter = NSDateFormatter.alloc.init
        dateFormatter.setDateFormat('yyyy-MM-dd')
        dateFormatter.dateFromString(value.to_s)
      end
    }
  })
  
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
  
  Adapter.register_transform(:integer, {
    serialize: lambda{|value|
      value.to_i
    },
    deserialize: lambda{|value|
      value.to_i
    }
  })
  
  Adapter.register_transform(:float, {
    serialize: lambda{|value|
      value.to_f
    },
    deserialize: lambda{|value|
      value.to_f
    }
  })
  
  Adapter.register_transform(:string, {
    serialize: lambda{|value|
      value.to_s
    },
    deserialize: lambda{|value|
      value.to_s
    }
  })
  
end