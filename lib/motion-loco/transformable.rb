module Loco
  
  module Transformable
    extend MotionSupport::Concern
    
  private
   
    def transform_value(type, value)
      # TODO: Transform values based on type
      if type == :integer && !value.nil?
        value.to_i
      else
        value
      end
    end
    
  end
  
end