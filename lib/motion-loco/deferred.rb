module Loco
  
  module Deferred
    
    # Add handlers to be called when the promise is rejected.
    # @param [Proc] reject A block of code to be called when the promise fails to resolve.
    def fail(reject)
      deferred.then(nil, reject)
    end
    
    # Call any failure handlers added to the deferred object.
    # @param [Object] value    The value to be passed to any failure handlers.
    # @param [Exception] error The exception to be passed to any failure handlers.
    def reject(value, error)
      deferred.reject(value, error)
      self
    end
    
    # Call any success handlers added to the deferred object.
    # @param [Object] value The value to be passed to any success handlers.
    def resolve(value)
      deferred.resolve(value)
      self
    end
    
    # Add handlers to be called when the deferred object is resolved or rejected.
    # @param [Proc] resolve A block of code to be called when done.
    # @param [Proc] reject  A block of code to be called when the promise fails to resolve.
    def then(resolve, reject=nil)
      deferred.then(resolve, reject)
      self
    end
    
  private
  
    def deferred
      @deferred ||= Loco::Promise.new
    end
    
  end
  
end