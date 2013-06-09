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
    
    def save_record(record, &block)
      raise NoMethodError, "Loco::Adapter subclasses must implement #save_record(record, &block)."
    end
    
    def transform_data_item(type, data)
      json = {}
      type.get_class_properties.each do |property|
        key = property[:name].to_sym
        # Loco.debug(self.class.get_class_transforms)
        transform = self.class.get_class_transforms[property[:type]]
        if transform
          json[key] = transform[:serialize].call(data[key])
        else
          json[key] = data[key]
        end
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
    
    class << self
  
      def register_transform(name, options={})
        @transforms = get_class_transforms
        @transforms[name.to_sym] = options
      end
      alias_method :registerTransform, :register_transform
      
      def get_class_transforms
        if @transforms.nil?
          @transforms = {}
          if self.superclass.respond_to? :get_class_transforms
            @transforms.merge!(self.superclass.get_class_transforms)
          end
        end
        @transforms
      end
      
    end
  end
  
  Adapter.register_transform(:integer, {
    serialize: lambda{|value|
      value.to_i
    },
    deserialize: lambda{|value|
      value.to_i
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