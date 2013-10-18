describe "Loco::Observable" do
  describe "- Loco::Observable Module" do
    it "should be defined" do
      Loco::Observable.class.should.equal Module
    end
  end
  
  describe "- Loco::Observable Model" do
    
    it "should be able to include it in a class" do
      should.not.raise(NoMethodError, TypeError) do
        module ObservableSpec
          class User
            include Loco::Observable
          end
        end
      end
    end
    
    it "should create a class attr `class_properties` that defaults to an empty Hash" do
      ObservableSpec::User.class_properties.should.equal({})
    end
    
    it "can define a property" do
      should.not.raise(NoMethodError, TypeError) do
        module ObservableSpec
          class User
            property :first_name
            property :lastName
          end
        end
      end
      
      ObservableSpec::User.class_properties.should.equal({ 
        firstName: { default: nil, type: nil }, 
        lastName:  { default: nil, type: nil }
      })
    end
    
    it "defined properties should default to nil" do
      @person = ObservableSpec::User.new
      @person.get(:first_name).should.equal nil
      @person.get(:lastName).should.equal nil
    end
    
    it "can set and get the value of a property" do
      @person = ObservableSpec::User.new
      @person.set(:first_name, "Brian")
      @person.get(:first_name).should.equal "Brian"
    end
    
    it "can use a string or a symbol to set and get the value of a property" do
      @person = ObservableSpec::User.new
      @person.set("first_name", "Brian")
      @person.get("first_name").should.equal "Brian"
    end
    
    it "accepts a Hash of properties on #new" do
      should.not.raise(NoMethodError, TypeError) do
        @person = ObservableSpec::User.new(
          first_name: "Brian",
          lastName:  "Pattison"
        )
      end
      @person.get(:first_name).should.equal "Brian"
      @person.get(:lastName).should.equal "Pattison"
    end
    
    it "can set and get the underscored and camelized versions of a property" do
      @person = ObservableSpec::User.new
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
        module ObservableSpec
          class User
            property :age, :integer
          end
        end
      end
      
      @person = ObservableSpec::User.new
      @person.set(:age, "100")
      @person.get(:age).should.equal 100
    end
    
    it "can define a property with a default value" do
      should.not.raise(NoMethodError, TypeError) do
        module ObservableSpec
          class User
            property :likes_pizza, :boolean, default: true
            property :slices_eaten, :integer, default: 0
          end
        end
      end
      
      @person = ObservableSpec::User.new
      @person.get(:likes_pizza).should.equal true
      @person.get(:slices_eaten).should.equal 0
    end
    
    it "can define a property with a default value without defining the type" do
      should.not.raise(NoMethodError, TypeError) do
        module ObservableSpec
          class User
            property :status, default: "waiting for pizza"
          end
        end
      end
      
      @person = ObservableSpec::User.new
      @person.get(:status).should.equal "waiting for pizza"
    end
    
    it "can set the value of any property to nil regardless of type and/or default value" do
      @person = ObservableSpec::User.new(
        first_name: "Brian",
        last_name: "Pattison",
        age: 31
      )
      @person.set(:first_name, nil)
      @person.set(:last_name, nil)
      @person.set(:age, nil)
      @person.set(:likes_pizza, nil)
      @person.set(:slices_eaten, nil)
      @person.set(:status, nil)
      
      @person.get(:first_name).should.equal nil
      @person.get(:last_name).should.equal nil
      @person.get(:age).should.equal nil
      @person.get(:likes_pizza).should.equal nil
      @person.get(:slices_eaten).should.equal nil
      @person.get(:status).should.equal nil
    end
    
  end
end