module Loco
  
  class Promise
    attr_accessor :is_fulfilled
    alias_method :isFulfilled,  :is_fulfilled
    alias_method :isFulfilled=, :is_fulfilled=
    
    attr_accessor :is_rejected
    alias_method :isRejected,  :is_rejected
    alias_method :isRejected=, :is_rejected=
    
    # Add handlers to be called when the promise is rejected.
    # @param [Proc] reject A block of code to be called when the promise fails to resolve.
    def fail(reject)
      self.then(nil, reject)
    end
    
    # Call any failure handlers added to the promise.
    # @param [Object] value    The value to be passed to any failure handlers.
    # @param [Exception] error The exception to be passed to any failure handlers.
    def reject(value, error)
      failure_handlers.each do |proc|
        proc.call(value, error)
      end
      self
    end
    
    # Call any success handlers added to the promise.
    # @param [Object] value The value to be passed to any success handlers.
    def resolve(value)
      success_handlers.each do |proc|
        proc.call(value)
      end
      self
    end
    
    # Add handlers to be called when the promise is resolved or rejected.
    # @param [Proc] resolve A block of code to be called when done.
    # @param [Proc] reject  A block of code to be called when the promise fails to resolve.
    def then(resolve, reject=nil)
      success_handlers << resolve unless resolve.nil?
      failure_handlers << reject  unless reject.nil?
      self
    end
    
  private
  
    def success_handlers
      @success_handlers ||= []
    end
    
    def failure_handlers
      @failure_handlers ||= []
    end
  end
  
end