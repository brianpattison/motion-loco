module Loco
  
  class Property
    attr_accessor :default, :is_cached, :observers, :proc, :target, :type, :value
    
    def get_value
      if self.is_cached || proc.nil?
        self.value
      else
        self.is_cached = true
        self.proc.call
      end
    end
    
    def initialize(params={})
      params.each do |key, value|
        self.send("#{key}=", value)
      end
      self.value = params[:default]
    end
    
    def observers
      @observers ||= []
    end
    
    def proc=(proc)
      # Remove any existing bindings
      self.observers.each do |observer|
        Loco.remove_observer(target, observer)
      end
      
      proc.observed_key_paths.each do |key_path|
        self.observers << Loco.observe(self.target, key_path, lambda {|target|
          # Mark the property as not cached when any of the key paths change
          self.is_cached = false
        })
      end
      
      super
    end
    
    def set_value(value)
      self.value = transform_value(value)
    end
    
    def transform_value(value)
      # TODO: Transform values based on type
      if self.type == :integer && !value.nil?
        value = value.to_i
      end
      value
    end
  end
  
end