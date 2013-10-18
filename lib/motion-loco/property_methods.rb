module Loco
  
  def self.get(target, path=nil)
    # If the target is a string, then we should be
    # trying to get a value from a Loco::Controller
    # Ex. Loco.get("GreetingController.message") # "Hello"
    if target.is_a?(String)
      target, path = get_target_and_path_from_string(target)
    end
    
    target, path = get_last_target_and_path(target, path)
    
    get_value(target, path)
  end
  
  def self.set(target, path, value=nil)
    # If the target is a string, then we should be
    # trying to set a value on a Loco::Controller
    # Ex. Loco.set("GreetingController.message", "Hello")
    if target.is_a?(String)
      value = path
      target, path = get_target_and_path_from_string(target)
    end
    
    target, path = get_last_target_and_path(target, path)
    
    set_value(target, path, value)
  end
  
private

  def self.get_last_target_and_path(target, path)
    split_path = path.split(".")
    path_count = split_path.length
    value = nil
    
    split_path.each_with_index do |key, index|
      get_value(target, key)
      
      if value && index + 1 < path_count
        target = value
        path = key
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
    elsif target.respond_to?(:get_property_value)
      value = target.get_property_value(key)
    end
    value
  end
  
  def self.normalize_key(key)
    key.to_s.camelize(:lower).to_sym
  end
  
  def self.set_value(target, key, value)
    key = normalize_key(key)
    if target.respond_to?("#{key}=")
      value = target.send("#{key}=", value)
    elsif target.respond_to?(:set_property_value)
      value = target.set_property_value(key, value)
    end
    value
  end
  
end