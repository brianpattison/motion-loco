describe "Loco" do
  describe "- Observer Methods" do
    
    it "can create an observer on an Objective-C property" do
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
    
    it "can remove an observer of an Objective-C property" do
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
    
    it "can create an observer on chained Objective-C properties" do
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
        property :last_name, :string
        property :car
        property :friends, :array
      end
      
      class Car
        include Loco::Observable
        property :color, :string
        property :driver
      end
    end
    
    it "can create an observer on a Loco::Observable property" do
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
    
    it "can remove an observer of a Loco::Observable property" do
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
    
    it "can create an observer on chained Loco::Observable properties" do
      @user = ObserverMethodsSpec::User.new
      @test_string = "Test"
      
      @observer = Loco.observe(@user, "car.driver.first_name", lambda{|target, key, old_value, new_value|
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
    
    it "can observe changes to each property in an array" do
      @user = ObserverMethodsSpec::User.new
      @friend1 = ObserverMethodsSpec::User.new
      @friend2 = ObserverMethodsSpec::User.new
      @friend_names_change_count = 0
      
      @observer = Loco.observe(@user, "friends.@each.first_name", lambda{|target, key, old_value, new_value|
        @friend_names_change_count += 1
      })
      
      wait 0.1 do
        @friend_names_change_count.should.equal 1
        
        wait 0.1 do
          @friend_names_change_count.should.equal 2
          
          wait 0.1 do
            @friend_names_change_count.should.equal 3
          
            wait 0.1 do
              @friend_names_change_count.should.equal 4
        
              Loco.remove_observer(@observer)
              Loco.observers.should.equal({})
            end
            
            Loco.set(@user, :friends, [@friend2])
          end
          
          Loco.set(@friend2, :first_name, "Billy")
        end
        
        Loco.set(@friend1, :first_name, "Joe")
      end
      
      Loco.set(@user, :friends, [@friend1, @friend2])
    end
    
    it "can observe a computed property" do
      module ObserverMethodsSpec
        class User
          property :full_name, lambda {|user|
            "#{user.get(:first_name)} #{user.get(:last_name)}"
          }.property(:first_name, :last_name)
        end
      end
      
      @user = ObserverMethodsSpec::User.new
      @test_string = "Test"
      
      @observer = Loco.observe(@user, :full_name, lambda{|target, key_path, old_value, new_value|
        @test_string = new_value
      })
    
      wait 0.1 do
        @test_string.should.equal "Hello "
        
        wait 0.1 do
          @test_string.should.equal "Hello World"
          
          Loco.remove_observer(@observer)
        end
        
        @user.set(:last_name, "World")
      end
    
      @user.set(:first_name, "Hello")
    end
    
    it "only calculates computed properties when needed" do
      @user = ObserverMethodsSpec::User.new(
        first_name: "Brian", 
        last_name: "Pattison"
      )
      
      @user.properties[:fullName].value.should.equal nil
      @user.properties[:fullName].is_cached.should.equal false
      
      @user.get(:full_name).should.equal "Brian Pattison"
      @user.properties[:fullName].value.should.equal "Brian Pattison"
      @user.properties[:fullName].is_cached.should.equal true
      
      @user.set(:first_name, "Kirsten")
      @user.properties[:fullName].value.should.equal "Brian Pattison"
      @user.properties[:fullName].is_cached.should.equal false
      @user.get(:full_name).should.equal "Kirsten Pattison"
    end
    
  end
end