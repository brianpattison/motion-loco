motion_require 'proc'

module Loco
  
  module Observable
    # Used to create observable view controllers.
    def init
      super
      initialize_bindings
      set_properties({})
      self
    end
    
    # Create new instance from a hash of properties with values.
    # @param [Hash] properties
    def initialize(properties={})
      super
      initialize_bindings
      set_properties(properties)
      self
    end
    
    # Change one or many properties from a hash of properties with values.
    # @param [Hash] properties_hash
    def set_properties(properties_hash)
      # Set the initial property values from the given hash
      properties_hash.each do |key, value|
        self.send("#{key}=", value)
      end
    end
    alias_method :setProperties, :set_properties
    
    # Change one or many properties from a hash of properties with values.
    # Only updates attributes defined with #property.
    # @param [Hash] properties_hash
    def update_attributes(properties_hash)
      self.class.get_class_properties.each do |property|
        key = property[:name].to_sym
        if properties_hash.has_key? key
          self.setValue(properties_hash[key], forKey:key)
        end
      end
    end
    alias_method :updateAttributes, :update_attributes
    
    def method_missing(method, *args, &block)
      if method.to_s.underscore.end_with?('_binding=')
        method = method.to_s.underscore.gsub('_binding=', '')
        if args.first.is_a?(String)
          if args.first =~ /^[A-Z]/
            split_args = args.first.split('.')
            target = split_args.slice!(0).constantize.instance
            key_path = split_args.join('.')
          else
            target = self
            key_path = args.first
          end
        else
          target = args.first.first
          key_path = args.first.last
        end
        key_path = key_path.to_s.underscore
        self.setValue(target.valueForKeyPath(key_path), forKey:method)
        register_observer(target, key_path) do
          self.setValue(target.valueForKeyPath(key_path), forKey:method)
        end
      else
        super
      end
    end
    
    def register_observer(target, key_path, &block)
      unless observer_is_registered?(target, key_path)
        target.addObserver(self, forKeyPath:key_path.to_s, options:0, context:nil) 
      end
      observers_for(target, key_path) << block
    end
    
    def remove_observer(target, key_path)
      target.removeObserver(self, forKeyPath:key_path)
      observers = observers_for(target, key_path)
      observers[target].delete(key_path) if observers[target].has_key?(key_path)
    end
    
    def remove_all_observers
      return if @observers.nil?
      @observers.each do |target, key_paths|
        key_paths.each_key do |key_path|
          target.removeObserver(self, forKeyPath:key_path)
        end
      end
      @observers.clear
    end
    
  private
  
    # Remove observers if the object is deallocated
    def dealloc
      self.remove_all_observers
      super
    end
  
    # Create the bindings for the computed properties and observers
    def initialize_bindings
      bindings = self.class.get_class_bindings
      
      bindings.each do |binding|
        binding[:proc].observed_properties.each do |key_path|
          key_path = key_path.to_s.underscore
          register_observer(self, key_path) do
            new_value = binding[:proc].call(self)
            if binding[:name]
              self.setValue(new_value, forKey:binding[:name])
            end
          end
        end
      end
    end

    def observeValueForKeyPath(key_path, ofObject:target, change:change, context:context)
      observers_for(target, key_path).each do |proc|
        proc.call
      end
    end
    
    def observer_is_registered?(target, key_path)
      return @observers && @observers[target] && @observers[target][key_path.to_s]
    end
    
    def observers_for(target, key_path)
      @observers ||= {}
      @observers[target] ||= {}
      @observers[target][key_path.to_s] ||= []
    end
    
    module ClassMethods
      def property(name, type=nil)
        name = name.to_s.underscore.to_sym
        @class_properties = get_class_properties
        
        unless @class_properties.include? name
          attr_accessor name
          camelized = name.to_s.camelize(:lower)
          if name.to_s != camelized
            alias_method camelized, name
            alias_method "#{camelized}=", "#{name}="
          end
        end
        
        if type.is_a? Proc
          @class_bindings = get_class_bindings
          @class_bindings << { name: name, proc: type }
        else
          type = type.to_sym unless type.nil?
          @class_properties << { name: name, type: type }
        end
      end
      
      def observer(name, proc)
        @class_bindings = get_class_bindings
        @class_bindings << { proc: proc }
      end
      
      # An array of the model's bindings
      # @return [Array]
      def get_class_bindings
        if @class_bindings.nil?
          @class_bindings = []
          if self.superclass.respond_to? :get_class_bindings
            @class_bindings.concat(self.superclass.get_class_bindings)
          end
        end
        @class_bindings
      end
      
      # An array of the model's properties
      # used for saving the record
      # @return [Array]
      def get_class_properties
        if @class_properties.nil?
          @class_properties = []
          if self.superclass.respond_to? :get_class_properties
            @class_properties.concat(self.superclass.get_class_properties)
          end
        end
        @class_properties
      end
      
      def get_class_relationships
        if @class_relationships.nil?
          @class_relationships = []
          if self.superclass.respond_to? :get_class_relationships
            @class_relationships.concat(self.superclass.get_class_relationships)
          end
        end
        @class_relationships
      end
      
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
  end
  
end