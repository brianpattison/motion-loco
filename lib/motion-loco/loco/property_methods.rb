module Loco
  
  # Returns the value for a key path for the target
  # whether the path includes Objective-C properties
  # or Loco::Observable properties.
  # @param [Object] target
  # @param [String] path
  # @return [Object]
  def self.get(target, path=nil)
    value = nil
    # If the target is a string, then we should be
    # trying to get a value from a Loco::Controller
    # Ex. Loco.get("GreetingController.message") # "Hello"
    if target.is_a?(String)
      target, path = get_target_and_path_from_string(target)
    end
  
    target, path = get_last_target_and_path(target, path)
  
    value = get_value(target, path)
    value
  end
  
  # Returns the camelized Symbol for the given String.
  # @param [String] key
  # @return [Symbol]
  def self.normalize_key(key)
    key.to_s.camelize(:lower).to_sym
  end
  
  # Sets the value for a key path for the target
  # whether the path includes Objective-C properties
  # or Loco::Observable properties.
  # @param [Object] target
  # @param [String] path
  # @param [Object] value
  def self.set(target, path, value=nil)
    # If the target is a string, then we should be
    # trying to set a value on a Loco::Controller
    # Ex. Loco.set("GreetingController.message", "Hello")
    if target.is_a?(String)
      value = path
      target, path = get_target_and_path_from_string(target)
    end
  
    target, path = get_last_target_and_path(target, path)
    
    value = set_value(target, path, value)
    value
  end
  
private

  def self.get_last_target_and_path(target, path)
    split_path = path.split(".")
    path_count = split_path.length
    path = split_path[0]
    value = nil
    
    split_path.each_with_index do |key, index|
      value = get_value(target, key)
      
      if value && index + 1 < path_count
        target = value
        path = split_path[index + 1]
      elsif value.nil?
        break
      end
    end
    
    [target, path]
  end
  
  def self.get_target_and_path_from_string(path)
    split_path = path.split(".")
    target = split_path.slice!(0).constantize
    path = split_path.join(".")
    [target, path]
  end
  
  def self.get_value(target, key)
    key = normalize_key(key)
    value = nil
    if target.respond_to?(key)
      value = target.send(key)
    elsif target.is_a?(Loco::Observable)
      value = target.send(:get_property_value, key)
    end
    value
  end
  
  def self.set_value(target, key, value)
    key = normalize_key(key)
    if target.respond_to?("#{key}=")
      old_value = target.send(key)
      new_value = target.send("#{key}=", value)
    elsif target.is_a?(Loco::Observable)
      old_value = target.send(:get_property_value, key)
      new_value = target.send(:set_property_value, key, value)
    end
    property_did_change(target, key, old_value, new_value) if old_value != new_value
    new_value
  end
  
end