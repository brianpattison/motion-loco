module Loco
  
  module Observable
    extend MotionSupport::Concern
    include Loco::Transformable
    
    included do
      attr_accessor :properties
      class_attribute :class_properties
    end
    
    # Returns the value for a key path
    # whether the path includes Objective-C properties
    # or Loco::Observable properties.
    # @param [String] path
    # @return [Object]
    def get(path)
      Loco.get(self, path)
    end
    
    # Create new instance from a hash of properties with values.
    # @param [Hash] params
    def initialize(params={})
      super
      initialize_properties
      params.each do |key, value|
        Loco.set(self, key, value)
      end
    end
    
    # Sets the value for a key path
    # whether the path includes Objective-C properties
    # or Loco::Observable properties.
    # @param [String] path
    # @param [Object] value
    def set(path, value)
      Loco.set(self, path, value)
    end
    
    module ClassMethods
      # Creates an property that can be accessed
      # using #get and #set and can be observed and
      # used for creating computed properties.
      # 
      # Example:
      # 
      #   class User
      #     include Loco::Observable
      #     property :name, :string
      #     property :login_count, :integer, default: 0
      #     property :mixed_type_property
      #   end
      # 
      # @param [Symbol] property_name
      # @param [Symbol] type
      # @param [Hash] options
      # @param [Object] options.default The default value for the property
      def property(property_name, type=nil, options={})
        property_name = Loco.normalize_key(property_name)
        
        if type.is_a?(Proc)
          self.computed_property(property_name, type)
        else
          # Grab options given with no type
          if type.is_a?(Hash)
            options = type
            type = nil
          end
          
          properties = self.class_properties || {}
          new_property = {}
          new_property[property_name] = {
            default: options[:default],
            type: type
          }
          
          self.class_properties = properties.merge(new_property)
        end
      end
      
    end
    
  private
  
    def get_property_value(key)
      self.properties[key]
    end
    
    def initialize_properties
      self.properties = {}
      self.class.class_properties.each do |key, options|
        self.send(:set_property_value, key, options[:default])
      end
    end
    
    def set_property_value(key, value)
      type = self.class.class_properties[key][:type]
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
    
  end
  
end