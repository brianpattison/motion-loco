module Loco
  
  # Returns a unique identifier for the target
  # to be used as the key for creating observers.
  # @param [Object] target
  # @return [String]
  def self.key_for_target(target)
    "#{target.class}-#{target.object_id}"
  end
  
  # Returns the normalized path for any key path,
  # whether the original path is underscore or camelized.
  # @param [String] key_path
  # @return [String]
  def self.normalize_path(key_path)
    key_path.to_s.camelize(:lower)
  end
  
  # Create an observer on a target and key path
  # that calls a code block when any part of
  # the key path changes.
  # 
  # Example:
  # 
  #   Loco.observe(@user, "team.is_admin", lambda{|target, key_path, old_value, new_value|
  #     # Do something with the new value
  #   })
  # 
  # @param [Object] target The object to be observed
  # @param [String] key_path The path on the target to be observed
  # @param [Proc] proc The code block to be called when a change occurs
  # @return [Loco::Observer]
  def self.observe(target, key_path, proc)
    observer = Loco::Observer.new(
      target: target,
      key_path: key_path,
      proc: proc 
    )
    observers_for_target_and_key(target, observer.key) << observer
    observer
  end
  
  # Returns a Hash where the keys are properties
  # of the target being observed, and the values
  # are an array of Loco::Observers that are to
  # be called when the property changes.
  # @param [Object] target
  # @return [Hash]
  def self.observers_for_target(target)
    key = key_for_target(target)
    observers[key] ||= {}
  end
  
  # Returns an array of Loco::Observers that are to
  # be called when the property changes on the target.
  # @param [Object] target
  # @param [String] key
  # @return [Array]
  def self.observers_for_target_and_key(target, key)
    key = normalize_key(key)
    observers_for_target(target)[key] ||= []
  end
  
  # Returns a Hash where the keys are unique
  # identifiers for the objects being observed
  # and the values are the same as 
  # Loco#observers_for_target(key).
  # @return [Hash]
  def self.observers
    @observers ||= {}
  end
  
  # Called when a property of a Loco::Observable object changes
  # in order to propagate changes to observers and bindings.
  # @param [Object] target
  # @param [String] key
  # @param [Object] old_value
  # @param [Object] new_value
  def self.property_did_change(target, key, old_value=nil, new_value=nil)
    self.observers_for_target_and_key(target, key).each do |observer|
      observer.value_did_change
    end
  end
  
  # Remove a Loco::Observer to prevent any future
  # changes from being propagated.
  # @param [Loco::Observer] observer
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
  
  # Remove all Loco::Observers from a target and/or key 
  # path to prevent any future changes from being propagated.
  # @param [Object] target
  # @param [String] key_path
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