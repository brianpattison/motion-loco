module Loco
  
  def self.bindings
    @bindings ||= {}
  end
  
  def self.bindings_for_target(target)
    key = key_for_target(target)
    bindings[key] ||= []
  end
  
  # Step one to creating a binding between two objects.
  # 
  # Example for binding a label to a user's name:
  # 
  #   Loco.bind(@label, :text).to(@user, :name)
  # 
  # @param [Object] target The object to pass the bound value to
  # @param [String] key_path The path on the target to pass the bound value to
  # @return [Loco::Binding]
  def self.bind(target, key_path)
    Loco::Binding.from(target, key_path)
  end
  
  # Remove a binding to prevent future changes from propagating.
  # @param [Loco::Binding] binding
  def self.remove_binding(binding)
    bindings = self.bindings[binding.from_target_key]
    if bindings
      bindings.delete(binding)
      if bindings.length == 0
        self.bindings.delete(binding.from_target_key)
      end
    end
    binding.dealloc
  end
  
end