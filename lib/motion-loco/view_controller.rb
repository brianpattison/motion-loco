motion_require 'observable'

module Loco
  
  class ViewController < UIViewController
    include Observable
    
    def title=(title)
      self.navigationItem.title = title
    end
  end
  
end