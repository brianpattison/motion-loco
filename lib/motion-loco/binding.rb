module Loco
  
  class Binding
    attr_accessor :from_key_path, :from_observer, :from_target, :from_target_key, :to_key_path, :to_observer, :to_target, :to_target_key
    
    def dealloc
      self.remove_observers
      super
    end
    
    def from_observer=(observer)
      @from_observer = WeakRef.new(observer)
    end
    
    def from_target=(target)
      @from_target_key = Loco.key_for_target(target)
      @from_target = WeakRef.new(target)
    end
    
    def initialize(from_target=nil, from_key_path=nil, to_target=nil, to_key_path=nil)
      self.from_target = from_target
      self.from_key_path = from_key_path
      self.to(to_target, to_key_path) unless to_target.nil?
      self
    end
    
    def remove_observers
      Loco.remove_observer(self.from_observer) if self.from_observer
      Loco.remove_observer(self.to_observer) if self.to_observer
    end
    alias_method :remove, :remove_observers
    
    def to(to_target, to_key_path)
      self.to_target = to_target
      self.to_key_path = to_key_path
      update_observers
      update_value
      self
    end
    
    def to_observer=(observer)
      @to_observer = WeakRef.new(observer)
    end
    
    def to_target=(target)
      @to_target_key = Loco.key_for_target(target)
      @to_target = WeakRef.new(target)
    end
    
    def self.from(from_target, from_key_path)
      binding = new(from_target, from_key_path)
      Loco.bindings_for_target(from_target) << binding
      binding
    end
    
  private
  
    def update_observers
      self.remove_observers
      self.to_observer = Loco.observe(self.to_target, self.to_key_path, lambda{|target, key_path, old_value, new_value|
        update_value
      })
    end
    
    def update_value
      if self.from_target && self.to_target
        Loco.set(self.from_target, self.from_key_path, Loco.get(self.to_target, self.to_key_path))
      end
    end
    
  end
  
end