module Loco
  
  def self.key_for_target(target)
    "#{target.class}-#{target.object_id}"
  end
  
  def self.normalize_path(key_path)
    key_path.to_s.camelize(:lower)
  end
  
  def self.observe(target, key_path, proc)
    observer = Loco::Observer.new(
      target: target,
      key_path: key_path,
      proc: proc 
    )
    observers_for_target_and_key(target, observer.key) << observer
    observer
  end
  
  def self.observers_for_target(target)
    key = key_for_target(target)
    observers[key] ||= {}
  end
  
  def self.observers_for_target_and_key(target, key)
    key = normalize_key(key)
    observers_for_target(target)[key] ||= []
  end
  
  def self.observers
    @observers ||= {}
  end
  
  def self.property_did_change(target, key, old_value=nil, new_value=nil)
    self.observers_for_target_and_key(target, key).each do |observer|
      observer.value_did_change
    end
  end
  
  def self.remove_observer(observer)
    observers_for_target_and_key = self.observers_for_target_and_key(observer.target, observer.key)
    
    observers_for_target_and_key.delete(observer)
    
    observer.array_observers.each do |observer|
      remove_observer(observer)
    end
    remove_observer(observer.next_observer) if observer.next_observer
    
    # Remove empty keys with no observers left
    self.observers.each do |target, hash|
      hash.each do |key, observers|
        if observers.length == 0
          hash.delete(key)
        end
      end
      if hash.keys.length == 0
        self.observers.delete(target)
      end
    end
  end
  
  def self.remove_observers(target, key_path=nil)
    if key_path.nil?
      self.observers.delete(key_for_target(target))
    else
      key_path = normalize_path(key_path)
      observers = observers_for_target(key_path)
      observers.delete(key_path)
      if observers.length == 0
        self.observers.delete(key_for_target(target))
      end
    end
  end
  
end