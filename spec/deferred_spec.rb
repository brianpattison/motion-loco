describe "Loco::Deferred" do
  describe "- Loco::Deferred Module" do
    it "should be defined" do
      Loco::Deferred.class.should.equal Module
    end
  end
  
  describe "- Loco::Deferred Model" do
    
    it "should include Loco::Deferred" do
      class DeferredModel
        include Loco::Deferred
      end
      DeferredModel.ancestors.member?(Loco::Deferred).should.equal true
    end
    
    it "should accept a Proc to run after the promise is done" do
      @promise = DeferredModel.new
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
      @promise = DeferredModel.new
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
      @promise = DeferredModel.new
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
      
        @promise = DeferredModel.new
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
      @promise = DeferredModel.new
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
      
        @promise = DeferredModel.new
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
end