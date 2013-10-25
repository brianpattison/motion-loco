module Loco
  
  module Observable
    extend MotionSupport::Concern
    
    included do
      attr_accessor :properties
      def properties
        @properties ||= {}
      end
      
      class_attribute :class_properties
      def self.class_properties
        @class_properties ||= {}
      end
    end
    
    def dealloc
      Loco.observers_for_target(self).each do |observer|
        Loco.remove_observer(observer)
      end
      super
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
      # Create a property that can be accessed
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
          
          properties = self.class_properties
          new_property = {}
          new_property[property_name] = {
            default: options[:default],
            key: property_name,
            type: type
          }
          
          self.class_properties = properties.merge(new_property)
        end
      end
      
      # Create a property that the behaves the same way a
      # static property, but is defined by a code block.
      # This method is typically not called directly.
      # 
      # Example:
      # 
      #   class User
      #     include Loco::Observable
      #     property :first_name, :string
      #     property :last_name, :string
      #     property :full_name, lambda {|user|
      #       "#{user.get(:first_name)} #{user.get(:last_name)}"
      #     }.property(:first_name, :last_name)
      #   end
      # 
      # @param [Symbol] property_name
      # @param [Proc] proc
      def computed_property(property_name, proc)
        property_name = Loco.normalize_key(property_name)
        
        properties = self.class_properties
        new_property = {}
        new_property[property_name] = {
          key: property_name,
          proc: proc
        }
        
        self.class_properties = properties.merge(new_property)
      end
      
    end
    
  private
  
    def get_property_value(key)
      if self.properties[key]
        self.properties[key].get_value
      else
        # Throw no method error?
      end
    end
    
    def initialize_properties
      self.class.class_properties.each do |key, options|
        self.properties[key] = Loco::Property.new(options.merge({ target: self }))
      end
    end
    
    def set_property_value(key, value)
      if self.properties[key]
        self.properties[key].set_value(value)
      else
        # Throw no method error?
      end
    end
  end
  
end