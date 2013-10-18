module Loco
  
  class Model
    include Loco::Associatable
    include Loco::Deferred
    include Loco::Observable
    property :id, :integer
  end
  
end