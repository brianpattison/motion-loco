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
          property :last_name
        end
        @person = Person.new
        @person.first_name = 'Brian'
        @person.last_name = 'Pattison'
      end
      @person.first_name.should.equal 'Brian'
      @person.last_name.should.equal 'Pattison'
    end
    
    it "should inherit properties on subclasses" do
      class User < Person
        property :age
      end
      User.get_class_properties.should.equal [:first_name, :last_name, :age]
    end
    
    it "defined properties should default to nil" do
      @person = Person.new
      @person.first_name.should.equal nil
      @person.last_name.should.equal nil
    end
    
    it "accepts a Hash of properties on #new" do
      should.not.raise(NoMethodError, TypeError) do
        @person = Person.new(
          first_name: 'Brian',
          last_name:  'Pattison'
        )
      end
      @person.first_name.should.equal 'Brian'
      @person.last_name.should.equal 'Pattison'
    end
    
    it "should be able to define a computed property" do
      class Person
        property :full_name, lambda{|object|
          "#{object.first_name} #{object.last_name}"
        }.property(:first_name, :last_name)
      end
      @person = Person.new(
        first_name: 'Brian',
        last_name:  'Pattison'
      )
      @person.full_name.should.equal 'Brian Pattison'
      
      @person.first_name = 'Billy'
      @person.full_name.should.equal 'Billy Pattison'
      
      @person.last_name = 'Bob'
      @person.full_name.should.equal 'Billy Bob'
    end
    
    it "should be able to create an observer" do
      class PersonWithObserver < Person
        observer :first_name_did_change, lambda{|object|
          object.last_name = 'Bob'
        }.observes(:first_name)
      end
      
      @person = PersonWithObserver.new
      @person.first_name = 'Billy'
      @person.last_name.should.equal 'Bob'
    end
    
    it "should be able to bind properties of other objects" do
      class Person
        property :sisters_name
      end
      @sister = Person.new(
        first_name: 'Kirsten', 
        last_name:  'Pattison'
      )
      @brother = Person.new(sisters_name_binding: [@sister, 'full_name'])
      
      @brother.sisters_name.should.equal 'Kirsten Pattison'
      
      @sister.first_name = 'Kir'
      @brother.sisters_name.should.equal 'Kir Pattison'
    end
    
    it "should be able to bind properties to a chain of objects" do
      class Person
        property :brother
        property :brothers_name
      end
      
      @brother = Person.new(
        first_name: 'Brian',
        last_name:  'Pattison'
      )
      @sister = Person.new(
        first_name: 'Kirsten', 
        last_name:  'Pattison',
        brothers_name_binding: 'brother.full_name'
      )
      @sister.brothers_name.should.equal nil
      
      @bound_to_brother = Person.new(
        first_name_binding: [@sister, 'brother.first_name'],
        last_name_binding:  [@sister, 'brother.last_name']
      )
      @bound_to_brother.first_name.should.equal nil
      @bound_to_brother.last_name.should.equal nil
      
      @sister.brother = @brother
      @sister.brothers_name.should.equal 'Brian Pattison'
      @bound_to_brother.full_name.should.equal 'Brian Pattison'
      
      @sister.brother.first_name = 'B'
      @sister.brother.last_name = 'Money'
      @sister.brothers_name.should.equal 'B Money'
      @bound_to_brother.full_name.should.equal 'B Money'
    end
    
    it "should be able to bind properties to singleton Loco::Controller using a string" do
      class PersonController < Loco::Controller
        property :content
      end
      
      @brother = Person.new(
        first_name: 'Brian',
        last_name:  'Pattison'
      )
      @sister = Person.new(
        first_name: 'Kirsten', 
        last_name:  'Pattison',
        brother_binding: 'PersonController.content'
      )
      
      @bound_to_brother = Person.new(
        first_name_binding: [@sister, 'brother.first_name'],
        last_name_binding:  'PersonController.content.last_name'
      )
      @bound_to_brother.first_name.should.equal nil
      @bound_to_brother.last_name.should.equal nil
      
      PersonController.content = @brother
      
      @sister.brother = @brother
      @bound_to_brother.full_name.should.equal 'Brian Pattison'
      
      PersonController.content.first_name = 'B'
      PersonController.content.last_name = 'Money'
      @bound_to_brother.full_name.should.equal 'B Money'
    end
    
  end
end