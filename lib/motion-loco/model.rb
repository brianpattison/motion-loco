motion_require 'observable'
motion_require 'savable'

module Loco
  
  class Model
    include Observable
    include Savable
    property :id
  end
  
end