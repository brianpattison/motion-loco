describe "Loco::Observable" do
  describe "- Loco::Observable Module" do
    it "should be defined" do
      Loco::Observable.class.should.equal Module
    end
  end
  
  describe "- Loco::Observable Model" do
    
    it "should include Loco::Observable" do
      class Person
        include Loco::Observable
      end
      Person.ancestors.member?(Loco::Observable).should.equal true
    end
    
    it "can define a property" do
      should.not.raise(NoMethodError, TypeError) do
        class Person
          property :first_name
          property :lastName
        end
      end
    end
    
    it "defined properties should default to nil" do
      @person = Person.new
      @person.get(:first_name).should.equal nil
      @person.get(:lastName).should.equal nil
    end
    
    it "can set and get the value of a property" do
      @person = Person.new
      @person.set(:first_name, "Brian")
      @person.get(:first_name).should.equal "Brian"
    end
    
    it "can use a string or a symbol to set and get the value of a property" do
      @person = Person.new
      @person.set("first_name", "Brian")
      @person.get("first_name").should.equal "Brian"
    end
    
    it "accepts a Hash of properties on #new" do
      should.not.raise(NoMethodError, TypeError) do
        @person = Person.new(
          first_name: "Brian",
          lastName:  "Pattison"
        )
      end
      @person.get(:first_name).should.equal "Brian"
      @person.get(:lastName).should.equal "Pattison"
    end
    
    it "can set and get the underscored and camelized versions of a property" do
      @person = Person.new
      @person.set(:first_name, "Brian")
      @person.set(:last_name, "Pattison")
      @person.get(:firstName).should.equal "Brian"
      @person.get(:lastName).should.equal "Pattison"
      
      @person.set(:firstName, "Billy")
      @person.get(:first_name).should.equal "Billy"
      @person.set(:lastName, "Bob")
      @person.get(:last_name).should.equal "Bob"
    end
    
    it "can define a property with a type used for transforming values" do
      should.not.raise(NoMethodError, TypeError) do
        class Person
          property :age, :integer
        end
      end
      
      @person = Person.new
      @person.set(:age, "100")
      @person.get(:age).should.equal 100
    end
    
    it "can define a property with a default value" do
      should.not.raise(NoMethodError, TypeError) do
        class Person
          property :likes_pizza, :boolean, defaut: true
          property :slices_eaten, :integer, default: 0
        end
      end
      
      @person = Person.new
      @person.get(:likes_pizza).should.equal true
      @person.get(:slices_eaten).should.equal 0
    end
    
    it "can define a property with a default value without defining the type" do
      should.not.raise(NoMethodError, TypeError) do
        class Person
          property :status, defaut: "waiting for pizza"
        end
      end
      
      @person = Person.new
      @person.get(:status).should.equal "waiting for pizza"
    end
    
    it "can set the value of any property to nil regardless of type and/or default value" do
      @person = Person.new(
        first_name: "Brian",
        last_name: "Pattison",
        age: 31
      )
      @person.set(:fist_name, nil)
      @person.set(:last_name, nil)
      @person.set(:age, nil)
      @person.set(:likes_pizza, nil)
      @person.set(:slices_eaten, nil)
      @person.set(:status, nil)
      
      @person.get(:fist_name).should.equal nil
      @person.get(:last_name).should.equal nil
      @person.get(:age).should.equal nil
      @person.get(:likes_pizza).should.equal nil
      @person.get(:slices_eaten).should.equal nil
      @person.get(:status).should.equal nil
    end
    
  end
end