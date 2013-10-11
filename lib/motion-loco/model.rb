module Loco
  
  class Model
    include Associatable
    include Observable
    property :id, :integer
  end
  
end