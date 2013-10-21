module Loco
  
  class Property
    attr_accessor :default, :is_cached, :key, :observers, :proc, :target, :type, :value
    
    def dealloc
      self.observers.each do |observer|
        Loco.remove_observer(observer)
      end
      super
    end
    
    def get_value
      if self.is_cached || self.proc.nil?
        unless self.is_cached
          self.is_cached = true
          self.value = transform_value(self.value)
        end
      else
        self.is_cached = true
        if self.proc.arity == 2
          self.value = self.proc.call(self.target, nil)
        else
          self.value = self.proc.call(self.target)
        end
      end
      self.value
    end
    
    def initialize(params={})
      params.each do |key, value|
        self.send("#{key}=", value)
      end
      self.value = params[:default]
      if self.proc
        initialize_observers
      end
    end
    
    def observers
      @observers ||= []
    end
    
    def set_value(value)
      self.is_cached = false
      if self.proc && self.proc.arity == 2
        self.value = self.proc.call(self.target, value)
      else
        self.value = value
      end
      self.value
    end
    
    def transform_value(value)
      # TODO: Transform values based on type
      if self.type == :integer && !value.nil?
        value = value.to_i
      elsif self.type == :array && value.nil?
        value = []
      end
      value
    end
    
  private
  
    def initialize_observers
      # Remove any existing bindings
      self.observers.each do |observer|
        Loco.remove_observer(target, observer)
      end
    
      self.proc.observed_key_paths.each do |key_path|
        self.observers << Loco.observe(self.target, key_path, lambda {|target, key_path, old_value, new_value|
          # Mark the property as not cached when any of the key paths change
          self.is_cached = false
          Loco.property_did_change(target, self.key)
        })
      end
    end
  end
  
end