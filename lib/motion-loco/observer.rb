module Loco
  
  class Observer
    attr_accessor :array_observers, :key, :key_path, :next_observer, :proc, :target, :target_key, :value
    
    def array_observers
      @array_observers ||= []
    end
    
    def initialize(params={})
      super
      self.target = params[:target]
      self.key_path = Loco.normalize_path(params[:key_path])
      self.key = self.key_path.split(".")[0].to_sym
      self.proc = params[:proc]
      self.value = Loco.get(self.target, self.key_path)
      update_next_observer
      self
    end
    
    def next_observer=(observer)
      @next_observer = WeakRef.new(observer)
    end
    
    def proc=(proc)
      @proc = WeakRef.new(proc)
    end
    
    def remove
      Loco.remove_observer(self)
    end
    
    def target=(target)
      @target_key = Loco.key_for_target(target)
      @target = WeakRef.new(target)
    end
    
    def value_did_change
      old_value = self.value
      new_value = Loco.get(self.target, self.key_path)
      self.value = new_value
      update_next_observer
      self.proc.call(self.target, self.key_path, old_value, new_value)
    end
    
  private
  
    def update_next_observer
      split_path = self.key_path.split(".")
      
      # Remove any previous observers
      self.array_observers.each do |observer|
        Loco.remove_observer(observer)
      end
      if self.next_observer
        Loco.remove_observer(self.next_observer)
      end
      
      # Observe changes down the key_path chain
      if split_path.length > 1 && split_path[0] != "@each" && split_path[1] != "@each"
        next_target = Loco.get(self.target, split_path[0])
        next_path = split_path[1..(split_path.length-1)].join(".")
        if next_target
          self.next_observer = Loco.observe(next_target, next_path, lambda{|target, key_path, old_value, new_value|
            self.value_did_change
          })
        end
      end
      
      # Observe property of each object in array
      if split_path[1] && split_path[1] == "@each"
        array_target = Loco.get(self.target, split_path[0])
        each_path = split_path[2..(split_path.length-1)].join(".")
        array_target.each do |each_target|
          self.array_observers << Loco.observe(each_target, each_path, lambda{|target, key_path, old_value, new_value|
            self.value_did_change
          })
        end
      end
    end
  end
  
end