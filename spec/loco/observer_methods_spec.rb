describe "Loco" do
  describe "- Observer Methods" do
    
    it "should be able to create an observer on an Objective-C property" do
      @label = UILabel.alloc.initWithFrame([[0, 0], [100, 100]])
      @test_string = "Test"
      
      @observer = Loco.observe(@label, :text, lambda{|target, key, old_value, new_value|
        @test_string = new_value
      })
      @observer.is_a?(Loco::Observer).should.equal true
    
      wait 0.1 do
        @test_string.should.equal "Hello World"
      end
      
      Loco.set(@label, :text, "Hello World")
    end
    
    it "should be able to remove an observer of an Objective-C property" do
      Loco.remove_observer(@observer)
      Loco.observers.should.equal({})
    end
    
    it "should accept underscore and camelized Objective-C property names" do
      @label = UILabel.alloc.initWithFrame([[0, 0], [100, 100]])
      @test_color = UIColor.redColor
      
      @observer = Loco.observe(@label, :text_color, lambda{|target, key, old_value, new_value|
        @test_color = new_value
      })
    
      wait 0.1 do
        @test_color.should.equal UIColor.greenColor
        Loco.remove_observer(@observer)
        Loco.observers.should.equal({})
        
        @label = UILabel.alloc.initWithFrame([[0, 0], [100, 100]])
        @test_color = UIColor.blueColor
      
        @observer = Loco.observe(@label, :textColor, lambda{|target, key, old_value, new_value|
          @test_color = new_value
        })
    
        wait 0.1 do
          @test_color.should.equal UIColor.yellowColor
          Loco.remove_observer(@observer)
          Loco.observers.should.equal({})
        end
      
        Loco.set(@label, :text_color, UIColor.yellowColor)
      end
      
      Loco.set(@label, :text_color, UIColor.greenColor)
    end
    
    it "should be able to create an observer on chained Objective-C properties" do
      @button = UIButton.alloc.initWithFrame([[0, 0], [200, 50]])
      @test_string = "Test"
      
      @observer = Loco.observe(@button, "titleLabel.text", lambda{|target, key_path, old_value, new_value|
        @test_string = new_value
      })
    
      wait 0.1 do
        @test_string.should.equal "Hello World"
        
        Loco.remove_observer(@observer)
        Loco.observers.should.equal({})
      end
      
      Loco.set(@button, "titleLabel.text", "Hello World")
    end
    
    module ObserverMethodsSpec
      class User
        include Loco::Observable
        property :first_name, :string
        property :car
      end
      
      class Car
        include Loco::Observable
        property :color, :string
        property :driver
      end
    end
    
    it "should be able to create an observer on a Loco::Observable property" do
      @user = ObserverMethodsSpec::User.new
      @test_string = "Test"
      
      @observer = Loco.observe(@user, :first_name, lambda{|target, key_path, old_value, new_value|
        @test_string = new_value
      })
    
      wait 0.1 do
        @test_string.should.equal "Hello World"
        
        Loco.remove_observer(@observer)
        Loco.observers.should.equal({})
      end
    
      @user.set(:first_name, "Hello World")
    end
    
    it "should be able to remove an observer of a Loco::Observable property" do
      Loco.remove_observer(@observer)
      Loco.observers.should.equal({})
    end
    
    it "should accept underscore and camelized Loco::Observable property names" do
      @user = ObserverMethodsSpec::User.new
      @test_string = "Test"
      
      @observer = Loco.observe(@user, :firstName, lambda{|target, key_path, old_value, new_value|
        @test_string = new_value
      })
      
      wait 0.1 do
        @test_string.should.equal "Hello World"
        
        Loco.remove_observer(@observer)
        Loco.observers.should.equal({})
        
        @user = ObserverMethodsSpec::User.new
        @test_string = "Test"
      
        @observer = Loco.observe(@user, :first_name, lambda{|target, key_path, old_value, new_value|
          @test_string = new_value
        })
    
        wait 0.1 do
          @test_string.should.equal "Hello World"
        
          Loco.remove_observer(@observer)
          Loco.observers.should.equal({})
        end
    
        @user.set(:firstName, "Hello World")
      end
    
      @user.set(:first_name, "Hello World")
    end
    
    it "should be able to create an observer on chained Loco::Observable properties" do
      @user = ObserverMethodsSpec::User.new
      @test_string = "Test"
      
      @observer = Loco.observe(@user, "car.driver.first_name", lambda{|target, key, old_value, new_value|
        Loco.debug("Change: #{old_value} -> #{new_value}")
        @test_string = new_value
      })
    
      wait 0.1 do
        @test_string.should.equal "Hello World"
        
        wait 0.1 do
          @test_string.should.equal "Brian"
          
          wait 0.1 do
            @test_string.should.equal nil
        
            Loco.remove_observer(@observer)
            Loco.observers.should.equal({})
          end
        
          Loco.set(@car, :driver, nil)
        end
        
        Loco.set(@car, "driver.firstName", "Brian")
      end
      
      @car = ObserverMethodsSpec::Car.new
      @car.set(:driver, ObserverMethodsSpec::User.new(first_name: "Hello World"))
      
      Loco.set(@user, :car, @car)
    end
    
  end
end