module Loco
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
    binding.remove
  end
  
end