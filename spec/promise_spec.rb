describe "Loco::Promise" do
  
  it "should be defined" do
    Loco::Promise.is_a?(Class).should.equal true
  end
  
  it "should accept a Proc to run after the promise is done" do
    @promise = Loco::Promise.new
    @returned_value = nil
    
    @promise.then(lambda{|value|
      @returned_value = value
    })
    
    wait 0.1 do
      @returned_value.should.equal "Hello"
    end
    
    @promise.resolve("Hello")
  end
  
  it "should accept a Proc to run after the promise has failed" do
    @promise = Loco::Promise.new
    @returned_value = nil
    @returned_error = nil
    
    @promise.fail(lambda{|value, error|
      @returned_value = value
      @returned_error = error
    })
    
    wait 0.1 do
      @returned_value.should.equal "No"
      @returned_error.should.equal "Error"
    end
    
    @promise.reject("No", "Error")
  end
  
  it "should accept a Proc to run after the promise is done or has failed" do
    @promise = Loco::Promise.new
    @returned_value = nil
    @returned_error = nil
    
    @promise.then(lambda{|value|
      @returned_value = value
    }, lambda{|value, error|
      @returned_value = value
      @returned_error = error
    })
    
    wait 0.1 do
      @returned_value.should.equal "Hello"
      @returned_error.should.equal nil
      
      @promise = Loco::Promise.new
      @returned_value = nil
      @returned_error = nil
    
      @promise.then(lambda{|value|
        @returned_value = value
      }, lambda{|value, error|
        @returned_value = value
        @returned_error = error
      })
    
      wait 0.1 do
        @returned_value.should.equal "No"
        @returned_error.should.equal "Error"
      end
    
      @promise.reject("No", "Error")
    end
    
    @promise.resolve("Hello")
  end
  
  it "should allow chaining of #then and #fail methods" do
    @promise = Loco::Promise.new
    @returned_value = nil
    @returned_error = nil
    
    @promise.then(lambda{|value|
      @returned_value = value
    }).fail(lambda{|value, error|
      @returned_value = value
      @returned_error = error
    })
    
    wait 0.1 do
      @returned_value.should.equal "Hello"
      @returned_error.should.equal nil
      
      @promise = Loco::Promise.new
      @returned_value = nil
      @returned_error = nil
    
      @promise.then(lambda{|value|
        @returned_value = value
      }).fail(lambda{|value, error|
        @returned_value = value
        @returned_error = error
      })
    
      wait 0.1 do
        @returned_value.should.equal "No"
        @returned_error.should.equal "Error"
      end
    
      @promise.reject("No", "Error")
    end
    
    @promise.resolve("Hello")
  end
  
end