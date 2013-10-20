module Loco
  
  class Observer
    attr_accessor :key, :key_path, :next_observer, :proc, :target, :value
    
    def initialize(params={})
      super
      self.target = params[:target]
      self.key_path = Loco.normalize_path(params[:key_path])
      self.key = self.key_path.split(".")[0].to_sym
      self.proc = params[:proc]
      self.value = Loco.get(self.target, self.key_path)
      update_next_observer
    end
    
    def remove
      Loco.remove_observer(self)
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
      if self.next_observer
        self.next_observer.remove
      end
      
      split_path = self.key_path.split(".")
      if split_path.length > 1
        next_target = Loco.get(self.target, split_path[0])
        next_path = split_path[1..(split_path.length-1)].join(".")
        if next_target
          self.next_observer = Loco.observe(next_target, next_path, lambda{|target, key_path, old_value, new_value|
            self.value_did_change
          })
        end
      end
    end
  end
  
end