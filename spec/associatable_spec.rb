describe "Loco::Associatable" do
  describe "- Loco::Associatable Module" do
    it "should be defined" do
      Loco::Associatable.class.should.equal Module
    end
  end
  
  describe "- Loco::Associatable Model" do
    
    it "should include Loco::Associatable" do
      class Car
        include Loco::Associatable
        include Loco::Observable
        property :model, :string
      end
      Car.ancestors.member?(Loco::Associatable).should.equal true
      Car.ancestors.member?(Loco::Observable).should.equal true
      
      class CarDriver
        include Loco::Associatable
        include Loco::Observable
        property :name, :string
      end
      CarDriver.ancestors.member?(Loco::Associatable).should.equal true
      CarDriver.ancestors.member?(Loco::Observable).should.equal true
      
      class CarSponsor
        include Loco::Associatable
        include Loco::Observable
        property :name, :string
      end
      CarSponsor.ancestors.member?(Loco::Associatable).should.equal true
      CarSponsor.ancestors.member?(Loco::Observable).should.equal true
    end
    
    it "can define a belongs_to relationship" do
      class Car
        belongs_to :car_driver
      end
      Car.get_class_relationships.should.equal [
        { belongs_to: :car_driver, class_name: nil }
      ]
    end
    
    it "can define a belongs_to relationship with a different name than the class" do
      class Car
        belongs_to :driver, class_name: CarDriver
      end
      Car.get_class_relationships.should.equal [
        { belongs_to: :car_driver, class_name: nil },
        { belongs_to: :driver, class_name: CarDriver }
      ]
    end
    
    it "can define a has_many relationship" do
      class Car
        has_many :car_sponsors
      end
      Car.get_class_relationships.should.equal [
        { belongs_to: :car_driver, class_name: nil },
        { belongs_to: :driver, class_name: CarDriver },
        { has_many: :car_sponsors, class_name: nil }
      ]
    end
    
    it "can define a has_many relationship with a different name than the class" do
      class Car
        has_many :sponsors, class_name: CarSponsor
      end
      Car.get_class_relationships.should.equal [
        { belongs_to: :car_driver, class_name: nil },
        { belongs_to: :driver, class_name: CarDriver },
        { has_many: :car_sponsors, class_name: nil },
        { has_many: :sponsors, class_name: CarSponsor }
      ]
    end
    
    it "can observe changes to belongs_to relationships" do
      class Car
        property :car_drivers_name, lambda{|car|
          car.car_driver.name if car.car_driver
        }.property('car_driver.name')
      end
      
      @car = Car.new(model: 'Toyota')
      @car.car_drivers_name.should.equal nil
      @car.carDriversName.should.equal nil
      
      @brian = CarDriver.new(name: 'Brian')
      @car.car_driver = @brian
      @car.car_drivers_name.should.equal 'Brian'
      @car.carDriversName.should.equal 'Brian'
      
      @kirsten = CarDriver.new(name: 'Kirsten')
      @car.carDriver = @kirsten
      @car.car_drivers_name.should.equal 'Kirsten'
      @car.carDriversName.should.equal 'Kirsten'
    end
    
    it "can observe changes to belongs_to relationships with a different name than the class" do
      class Car
        property :driversName, lambda{|car|
          car.driver.name if car.driver
        }.property('driver.name')
      end
      
      @car = Car.new
      @car.drivers_name.should.equal nil
      @car.driversName.should.equal nil
      
      @brian = CarDriver.new(name: 'Brian')
      @car.driver = @brian
      @car.drivers_name.should.equal 'Brian'
      @car.driversName.should.equal 'Brian'
      
      @kirsten = CarDriver.new(name: 'Kirsten')
      @car.driver = @kirsten
      @car.drivers_name.should.equal 'Kirsten'
      @car.driversName.should.equal 'Kirsten'
    end
    
    it "can observe changes to the length of a has_many relationships" do
      class Car
        property :car_sponsors_count, lambda{|car|
          car.car_sponsors.length
        }.property('car_sponsors.length')
      end
      
      @car = Car.new
      @car.car_sponsors_count.should.equal 0
      @car.carSponsorsCount.should.equal 0
      
      @car.car_sponsors << CarSponsor.new("Brian's Burger Shop")
      @car.car_sponsors_count.should.equal 1
      @car.carSponsorsCount.should.equal 1
      
      @car.carSponsors << CarSponsor.new("Pete's Pizza Place")
      @car.car_sponsors_count.should.equal 2
      @car.carSponsorsCount.should.equal 2
    end
    
    it "can observe changes to the length of a has_many relationships with a different name than the class" do
      class Car
        property :sponsors_count, lambda{|car|
          car.sponsors.length
        }.property('sponsors.length')
      end
      
      @car = Car.new
      @car.sponsors_count.should.equal 0
      @car.sponsorsCount.should.equal 0
      
      @car.sponsors << CarSponsor.new("Brian's Burger Shop")
      @car.sponsors_count.should.equal 1
      @car.sponsorsCount.should.equal 1
      
      @car.sponsors << CarSponsor.new("Pete's Pizza Place")
      @car.sponsors_count.should.equal 2
      @car.sponsorsCount.should.equal 2
    end
    
  end
end