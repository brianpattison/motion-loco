describe "Loco" do
  describe "- Binding Methods" do
    
    it "should be able to create a binding on an Objective-C property" do
      @label1 = UILabel.alloc.initWithFrame([[0, 0], [100, 100]])
      @label2 = UILabel.alloc.initWithFrame([[0, 0], [100, 100]])
      @binding = Loco.bind(@label1, :text).to(@label2, :text)
      @binding.is_a?(Loco::Binding).should.equal true
      
      wait 0.1 do
        Loco.get(@label1, :text).should.equal "Hello World"
      end
      
      Loco.set(@label2, :text, "Hello World")
    end
    
    it "should be able to remove a binding of an Objective-C property" do
      Loco.remove_binding(@binding)
      Loco.observers.should.equal({})
    end
    
    it "should accept underscore and camelized Objective-C property names" do
      @label1 = UILabel.alloc.initWithFrame([[0, 0], [100, 100]])
      @label2 = UILabel.alloc.initWithFrame([[0, 0], [100, 100]])
      @binding = Loco.bind(@label1, :text_color).to(@label2, :textColor)
      
      wait 0.1 do
        Loco.get(@label1, :textColor).should.equal UIColor.greenColor
        Loco.remove_binding(@binding)
        Loco.observers.should.equal({})
      end
      
      Loco.set(@label2, :text_color, UIColor.greenColor)
    end
    
    it "should be able to create a binding on chained Objective-C properties" do
      @button1 = UIButton.alloc.initWithFrame([[0, 0], [200, 50]])
      @button2 = UIButton.alloc.initWithFrame([[0, 0], [200, 50]])
      @binding = Loco.bind(@button1, "titleLabel.text").to(@button2, "titleLabel.text")
    
      wait 0.1 do
        Loco.get(@button1, "titleLabel.text").should.equal "Hello World"
        Loco.remove_binding(@binding)
        Loco.observers.should.equal({})
      end
      
      Loco.set(@button2, "titleLabel.text", "Hello World")
    end
    
    module BindingMethodsSpec
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
    
    it "should be able to create a binding on a Loco::Observable property" do
      @user1 = BindingMethodsSpec::User.new
      @user2 = BindingMethodsSpec::User.new
      @binding = Loco.bind(@user1, :first_name).to(@user2, :first_name)
      
      wait 0.1 do
        Loco.get(@user1, :first_name).should.equal "Hello World"
      end
      
      Loco.set(@user2, :first_name, "Hello World")
    end
    
    it "should be able to remove a binding of a Loco::Observable property" do
      Loco.remove_binding(@binding)
      Loco.observers.should.equal({})
    end
    
    it "should accept underscore and camelized Loco::Observable property names" do
      @user1 = BindingMethodsSpec::User.new
      @user2 = BindingMethodsSpec::User.new
      @binding = Loco.bind(@user1, :firstName).to(@user2, :firstName)
      
      wait 0.1 do
        @user1.get(:first_name).should.equal "Hello World"
        
        Loco.remove_binding(@binding)
        Loco.observers.should.equal({})
        
        @user1 = BindingMethodsSpec::User.new
        @user2 = BindingMethodsSpec::User.new
        @binding = Loco.bind(@user1, :first_name).to(@user2, :first_name)
    
        wait 0.1 do
          @user1.get(:firstName).should.equal "Hello World"
        
          Loco.remove_binding(@binding)
          Loco.observers.should.equal({})
        end
    
        @user2.set(:firstName, "Hello World")
      end
    
      @user2.set(:first_name, "Hello World")
    end
    
    it "should be able to create a binding on chained Loco::Observable properties" do
      @user1 = BindingMethodsSpec::User.new
      @user2 = BindingMethodsSpec::User.new
      @binding = Loco.bind(@user1, "first_name").to(@user2, "car.driver.first_name")
    
      wait 0.1 do
        @user1.get("first_name").should.equal "Hello World"
        
        wait 0.1 do
          @user1.get("first_name").should.equal "Brian"
          
          wait 0.1 do
            @user1.get("first_name").should.equal nil
        
            Loco.remove_binding(@binding)
            Loco.observers.should.equal({})
          end
        
          Loco.set(@car, :driver, nil)
        end
        
        Loco.set(@car, "driver.firstName", "Brian")
      end
      
      @car = BindingMethodsSpec::Car.new
      @car.set(:driver, BindingMethodsSpec::User.new(first_name: "Hello World"))
      
      Loco.set(@user2, :car, @car)
    end
    
  end
end