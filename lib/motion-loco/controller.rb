motion_require 'observable'

module Loco
  
  class Controller
    include Observable
  
    def self.instance
      @instance ||= new
    end
    
    def self.method_missing(method, *args, &block)
      if self.instance.respond_to? method
        self.instance.send(method, *args)
      else
        super
      end
    end
  end
  
end