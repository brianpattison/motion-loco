describe "Loco" do
  describe "- Property Methods" do
    
    it "should get the value of Objective-C properties from an object" do
      @label = UILabel.alloc.initWithFrame([[0, 0], [100, 100]])
      @label.text = "Hello World"
      Loco.get(@label, :text).should.equal "Hello World"
    end
    
    it "should set the value of Objective-C properties on an object" do
      @label = UILabel.alloc.initWithFrame([[0, 0], [100, 100]])
      Loco.set(@label, :text, "Hello World")
      @label.text.should.equal "Hello World"
    end
    
    it "should accept underscore and camelized Objective-C property names" do
      @label = UILabel.alloc.initWithFrame([[0, 0], [100, 100]])
      Loco.set(@label, :highlighted_text_color, UIColor.blueColor)
      @label.highlightedTextColor.should.equal UIColor.blueColor

      @label.highlightedTextColor =  UIColor.redColor
      Loco.get(@label, :highlighted_text_color).should.equal UIColor.redColor
      
      Loco.set(@label, :highlightedTextColor, UIColor.blueColor)
      @label.highlightedTextColor.should.equal UIColor.blueColor

      @label.highlightedTextColor =  UIColor.redColor
      Loco.get(@label, :highlightedTextColor).should.equal UIColor.redColor
    end
    
    it "should set and get the value of chained Objective-C properties" do
      @button = UIButton.alloc.initWithFrame([[0, 0], [200, 50]])
      
      Loco.set(@button, "titleLabel.text", "Hello")
      @button.titleLabel.text.should.equal "Hello"
      
      @button.titleLabel.text = "Goodbye"
      Loco.get(@button, "titleLabel.text").should.equal "Goodbye"
    end
    
    module PropertyMethodsSpec
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
    
    it "should get the value of Loco::Observable properties from an object" do
      @user = PropertyMethodsSpec::User.new(first_name: "Brian")
      Loco.get(@user, :first_name).should.equal "Brian"
    end
    
    it "should set the value of Loco::Observable properties on an object" do
      @user = PropertyMethodsSpec::User.new
      Loco.set(@user, :first_name, "Kirsten").should.equal "Kirsten"
      Loco.get(@user, :first_name).should.equal "Kirsten"
    end
    
    it "should accept underscore and camelized Loco::Observable property names" do
      @user = PropertyMethodsSpec::User.new
      
      Loco.set(@user, :first_name, "Brian").should.equal "Brian"
      Loco.get(@user, :firstName).should.equal "Brian"
      
      Loco.set(@user, :firstName, "Kirsten").should.equal "Kirsten"
      Loco.get(@user, :first_name).should.equal "Kirsten"
    end
    
    it "should set and get the value of chained Loco::Observable properties" do
      @user = PropertyMethodsSpec::User.new(first_name: "Kirsten")
      Loco.get(@user, 'car.color').should.equal nil
      Loco.get(@user, 'car.driver.first_name').should.equal nil
      
      @car = PropertyMethodsSpec::Car.new(color: "blue")
      Loco.set(@user, :car, @car)
      
      Loco.get(@user, "car.color").should.equal "blue"
      Loco.set(@user, "car.color", "red").should.equal "red"
      Loco.get(@user, "car.color").should.equal "red"
      
      Loco.get(@user, "car.driver.first_name").should.equal nil
      Loco.set(@car, :driver, PropertyMethodsSpec::User.new(first_name: "Brian"))
      Loco.get(@user, "car.driver.first_name").should.equal "Brian"
      Loco.set(@user, "car.driver.first_name", "Billy Bob").should.equal "Billy Bob"
      Loco.get(@user, "car.driver.first_name").should.equal "Billy Bob"
    end
    
  end
end