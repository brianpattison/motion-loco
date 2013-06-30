describe "Loco::Adapter" do
  
  describe "- Subclasses" do
    
    class MyAdapter < Loco::Adapter
    end
    
    it "should be defined" do
      Loco::MyAdapter.ancestors.member?(Loco::Adapter).should.equal true
    end
    
    it "should throw errors for undefined methods" do
      @adapter = MyAdapter.new
      should.raise NoMethodError do
        @adapter.create_record(nil)
      end
      should.raise NoMethodError do
        @adapter.find(nil, nil)
      end
      should.raise NoMethodError do
        @adapter.find_all(nil, nil)
      end
      should.raise NoMethodError do
        @adapter.find_many(nil, nil, nil)
      end
      should.raise NoMethodError do
        @adapter.find_query(nil, nil, nil)
      end
      should.raise NoMethodError do
        @adapter.save_record(nil)
      end
      should.raise NoMethodError do
        @adapter.delete_record(nil)
      end
    end
    
    it "should transform dates" do
      transforms = Loco::Adapter.get_transforms[:date]
      date = '2013-06-09'
      
      date = transforms[:deserialize].call(date)
      date.is_a?(NSDate).should.equal true
      
      date = transforms[:serialize].call(date)
      date.should.equal '2013-06-09'
    end
    
    it "should transform floats" do
      transforms = Loco::Adapter.get_transforms[:float]
      
      float = '12.34567'
      float = transforms[:deserialize].call(float)
      float.should.equal 12.34567
      
      float = '34.56789'
      float = transforms[:serialize].call(float)
      float.should.equal 34.56789
    end
    
    it "should transform integers" do
      transforms = Loco::Adapter.get_transforms[:integer]
      
      integer = '1234567'
      integer = transforms[:deserialize].call(integer)
      integer.should.equal 1234567
      
      integer = '3456789'
      integer = transforms[:serialize].call(integer)
      integer.should.equal 3456789
    end
    
    it "should transform strings" do
      transforms = Loco::Adapter.get_transforms[:string]
      
      string = 1234567
      string = transforms[:deserialize].call(string)
      string.should.equal '1234567'
      
      string = 3456789
      string = transforms[:serialize].call(string)
      string.should.equal '3456789'
    end
    
  end
  
end