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
    
    # Used to create observable views.
    def initWithFrame(frame)
      super
      initialize_bindings
      set_properties({})
      self
    end
    
    # Used to create observable table view cells
    def initWithStyle(style, reuseIdentifier:reuseIdentifier)
      super
      initialize_bindings
      set_properties({})
      self
    end
    
    # Change one or many properties from a hash of properties with values.
    # @param [Hash] properties
    def set_properties(hash)
      # Set the initial property values from the given hash
      hash.each do |key, value|
        self.send("#{key}=", value)
      end
    end
    
    def method_missing(method, *args, &block)
      if method.end_with?('_binding=') || method.end_with?('Binding=')
        method = method.gsub('_binding=', '').gsub('Binding=', '')
        if args.first.is_a?(String)
          if args.first =~ /^[A-Z]/
            split_args = args.first.split('.')
            target = Kernel.const_get(split_args.slice!(0)).instance
            key_path = split_args.join('.')
          else
            target = self
            key_path = args.first
          end
        else
          target = args.first.first
          key_path = args.first.last
        end
        self.send("#{method}=", target.valueForKeyPath(key_path))
        register_observer(target, key_path) do
          self.send("#{method}=", target.valueForKeyPath(key_path))
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
  
    # Create the bindings for the computed properties and observers
    def initialize_bindings
      bindings = self.class.send(:get_class_bindings)
      
      bindings.each do |binding|
        binding[:proc].observed_properties.each do |key_path|
          register_observer(self, key_path) do
            new_value = binding[:proc].call(self)
            if binding[:name]
              self.send("#{binding[:name]}=", new_value)
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
    
    def dealloc
      self.remove_all_observers
      super
    end
    
    module ClassMethods
      def property(name, proc=nil)
        name = name.to_sym
        @class_properties = get_class_properties
        
        unless @class_properties.include? name
          attr_accessor name
          @class_properties << name
        end
        
        unless proc.nil?
          @class_bindings = get_class_bindings
          @class_bindings << { name: name, proc: proc }
        end
      end
      
      def observer(name, proc)
        @class_bindings = get_class_bindings
        @class_bindings << { proc: proc }
      end
      
      # An array of the model's bindings
      # @return [Array]
      def get_class_bindings
        @class_bindings ||= []
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
      
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
  end
  
end