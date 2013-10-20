module Loco
  
  class ::Proc
    def observed_key_paths
      @observed_key_paths ||= []
    end
    
    def observes(*key_paths)
      key_paths.each {|key_path|
        self.observed_key_paths << key_path
      }
      self
    end
    alias_method :property, :observes
  end
  
end