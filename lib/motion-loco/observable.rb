module Loco
  
  module Observable
    extend MotionSupport::Concern
    include MotionSupport::DescendantsTracker
    
    included do
      attr_accessor :properties
      cattr_accessor :class_properties do
        {}
      end
    end
    
    def get(path)
      Loco.get(self, path)
    end
    
    def get_property_value(key)
      self.properties[key]
    end
    
    def initialize(params={})
      super
      initialize_properties
      params.each do |key, value|
        Loco.set(self, key, value)
      end
    end
    
    def initialize_properties
      self.properties = {}
      self.class_properties.each do |key, options|
        self.set_property_value(key, options[:default])
      end
    end
    
    def set(path, value)
      Loco.set(self, path, value)
    end
    
    def set_property_value(key, value)
      type = self.class_properties[key][:type]
      value = transform_value(type, value)
      self.properties[key] = value
    end
    
    def transform_value(type, value)
      # TODO: Transform values based on type
      if type == :integer && !value.nil?
        value.to_i
      else
        value
      end
    end
    
    module ClassMethods
      
      def property(property_name, type=nil, options={})
        property_name = property_name.to_s.camelize(:lower)
        
        if type.is_a?(Hash)
          options = type
          type = nil
        end
        
        self.class_properties[property_name.to_sym] = {
          default: options[:default],
          type: type
        }
      end
      
    end
    
  end
  
end