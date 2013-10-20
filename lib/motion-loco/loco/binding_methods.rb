module Loco
  
  def self.bind(target, key_path)
    Loco::Binding.from(target, key_path)
  end
  
  def self.remove_binding(binding)
    binding.remove
  end
  
end