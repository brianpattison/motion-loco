describe "Loco::Model" do
  
  it "should be defined" do
    Loco::Model.ancestors.member?(Loco::Observable).should.equal true
  end
  
  it "should return an instance of the model on #find" do
    @show = Show.find(1)
    @show.id.should.equal 1
    
    @show = Show.find(2)
    @show.id.should.equal 2
  end
  
  it "should return a Loco::RecordArray on #all" do
    @shows = Show.all
    @shows.is_a?(Loco::RecordArray).should.equal true
  end
  
  it "should return a Loco::RecordArray on #where" do
    @episodes = Episode.where(show_id: 1)
    @episodes.is_a?(Loco::RecordArray).should.equal true
  end
  
  it "should include the root on serialization" do
    @show = Show.find(1)
    @hash = @show.serialize
    @hash[:show].nil?.should.equal false
  end
  
  it "should accept an option to not include root" do
    @show = Show.find(1)
    @hash = @show.serialize(root: false)
    @hash[:show].nil?.should.equal true
  end
  
  it "should accept an option to change the root used" do
    @show = Show.find(1)
    @hash = @show.serialize(root: 'podcast')
    @hash[:podcast].nil?.should.equal false
  end
  
  it "should accept option to include ID on serialization" do
    @show = Show.find(1)
    @hash = @show.serialize(include_id: true)
    @hash[:show][:id].should.equal 1
  end
  
end