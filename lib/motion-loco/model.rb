motion_require 'observable'
motion_require 'record_array'

module Loco
  
  class Model
    include Associatable
    include Observable
    include Persistable
    property :id, :integer
  end
  
end