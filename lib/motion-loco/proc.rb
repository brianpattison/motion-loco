module Loco
  
  class ::Proc
    attr_reader :observed_properties
    def observed_properties
      @observed_properties ||= []
    end
    
    def observes(*properties)
      properties.each {|property|
        self.observed_properties << property
      }
      self
    end
    
    def property(*properties)
      properties.each {|property|
        self.observed_properties << property
      }
      self
    end
  end
  
end