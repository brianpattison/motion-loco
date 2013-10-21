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
      @user = ObservableSpec::User.new
      @user.get(:first_name).should.equal nil
      @user.get(:lastName).should.equal nil
    end
    
    it "can set and get the value of a property" do
      @user = ObservableSpec::User.new
      @user.set(:first_name, "Brian")
      @user.get(:first_name).should.equal "Brian"
    end
    
    it "can use a string or a symbol to set and get the value of a property" do
      @user = ObservableSpec::User.new
      @user.set("first_name", "Brian")
      @user.get("first_name").should.equal "Brian"
    end
    
    it "accepts a Hash of properties on #new" do
      should.not.raise(NoMethodError, TypeError) do
        @user = ObservableSpec::User.new(
          first_name: "Brian",
          lastName:  "Pattison"
        )
      end
      @user.get(:first_name).should.equal "Brian"
      @user.get(:lastName).should.equal "Pattison"
    end
    
    it "can set and get the underscored and camelized versions of a property" do
      @user = ObservableSpec::User.new
      @user.set(:first_name, "Brian")
      @user.set(:last_name, "Pattison")
      @user.get(:firstName).should.equal "Brian"
      @user.get(:lastName).should.equal "Pattison"
      
      @user.set(:firstName, "Billy")
      @user.get(:first_name).should.equal "Billy"
      @user.set(:lastName, "Bob")
      @user.get(:last_name).should.equal "Bob"
    end
    
    it "can define a property with a type used for transforming values" do
      should.not.raise(NoMethodError, TypeError) do
        module ObservableSpec
          class User
            property :age, :integer
          end
        end
      end
      
      ObservableSpec::User.class_properties.should.equal({ 
        firstName: { default: nil, type: nil }, 
        lastName:  { default: nil, type: nil },
        age:       { default: nil, type: :integer }
      })
      
      @user = ObservableSpec::User.new
      @user.set(:age, "100")
      @user.get(:age).should.equal 100
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
      
      ObservableSpec::User.class_properties.should.equal({ 
        firstName:   { default: nil,  type: nil }, 
        lastName:    { default: nil,  type: nil },
        age:         { default: nil,  type: :integer },
        likesPizza:  { default: true, type: :boolean },
        slicesEaten: { default: 0,    type: :integer }
      })
      
      @user = ObservableSpec::User.new
      @user.get(:likes_pizza).should.equal true
      @user.get(:slices_eaten).should.equal 0
    end
    
    it "can define a property with a default value without defining the type" do
      should.not.raise(NoMethodError, TypeError) do
        module ObservableSpec
          class User
            property :status, default: "waiting for pizza"
          end
        end
      end
      
      ObservableSpec::User.class_properties.should.equal({ 
        firstName:   { default: nil,  type: nil }, 
        lastName:    { default: nil,  type: nil },
        age:         { default: nil,  type: :integer },
        likesPizza:  { default: true, type: :boolean },
        slicesEaten: { default: 0,    type: :integer },
        status:      { default: "waiting for pizza", type: nil }
      })
      
      @user = ObservableSpec::User.new
      @user.get(:status).should.equal "waiting for pizza"
    end
    
    it "can set the value of any property to nil regardless of type and/or default value" do
      @user = ObservableSpec::User.new(
        first_name: "Brian",
        last_name: "Pattison",
        age: 31
      )
      @user.set(:first_name, nil)
      @user.set(:last_name, nil)
      @user.set(:age, nil)
      @user.set(:likes_pizza, nil)
      @user.set(:slices_eaten, nil)
      @user.set(:status, nil)
      
      @user.get(:first_name).should.equal nil
      @user.get(:last_name).should.equal nil
      @user.get(:age).should.equal nil
      @user.get(:likes_pizza).should.equal nil
      @user.get(:slices_eaten).should.equal nil
      @user.get(:status).should.equal nil
    end
    
    it "should pass parent class properties down to child classes" do
      module ObservableSpec
        class Admin < ObservableSpec::User
          property :is_admin, :boolean, default: true
        end
      end
      
      ObservableSpec::Admin.class_properties.should.equal({ 
        firstName:   { default: nil,  type: nil }, 
        lastName:    { default: nil,  type: nil },
        age:         { default: nil,  type: :integer },
        likesPizza:  { default: true, type: :boolean },
        slicesEaten: { default: 0,    type: :integer },
        status:      { default: "waiting for pizza", type: nil },
        isAdmin:     { default: true, type: :boolean }
      })
      
      @admin = ObservableSpec::Admin.new(first_name: "Brian")
      @admin.get(:first_name).should.equal "Brian"
      @admin.get(:last_name).should.equal nil
      @admin.get(:age).should.equal nil
      @admin.get(:likes_pizza).should.equal true
      @admin.get(:slices_eaten).should.equal 0
      @admin.get(:status).should.equal "waiting for pizza"
      @admin.get(:is_admin).should.equal true
    end
    
    it "should not pass the child properties back up to the parent class" do
      ObservableSpec::User.class_properties.should.equal({ 
        firstName:   { default: nil,  type: nil }, 
        lastName:    { default: nil,  type: nil },
        age:         { default: nil,  type: :integer },
        likesPizza:  { default: true, type: :boolean },
        slicesEaten: { default: 0,    type: :integer },
        status:      { default: "waiting for pizza", type: nil }
      })
      
      @user = ObservableSpec::User.new(slicesEaten: 5)
      @user.get(:first_name).should.equal nil
      @user.get(:last_name).should.equal nil
      @user.get(:age).should.equal nil
      @user.get(:likes_pizza).should.equal true
      @user.get(:slices_eaten).should.equal 5
      @user.get(:status).should.equal "waiting for pizza"
      @user.get(:is_admin).should.equal nil
    end
    
    it "should be able to override defaults on child classes" do
      module ObservableSpec
        class BadAdmin < ObservableSpec::Admin
          property :is_admin, :boolean, default: false
        end
      end
      
      @bad_admin = ObservableSpec::BadAdmin.new
      @bad_admin.get(:is_admin).should.equal false
      
      @good_admin = ObservableSpec::Admin.new
      @good_admin.get(:is_admin).should.equal true
    end
    
    it "can define a computed property" do
      should.not.raise(NoMethodError, TypeError) do
        module ObservableSpec
          class User
            property :full_name, lambda {|user|
              "#{user.get(:first_name)} #{user.get(:last_name)}"
            }.property(:first_name, :last_name)
          end
        end
      end
      
      @user = ObservableSpec::User.new
      @user.get(:full_name).should.equal " "
      
      @user.set(:first_name, "Brian")
      @user.get(:full_name).should.equal "Brian "
      
      @user.set(:lastName, "Pattison")
      @user.get(:fullName).should.equal "Brian Pattison"
    end
    
  end
end