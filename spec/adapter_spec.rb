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
    
    it "should use registered transforms when loading data" do
      @episode = Episode.find(1)
      @episode.episode_number.should.equal 20
    end
    
  end
  
  
  
end