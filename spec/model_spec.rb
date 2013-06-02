describe "Loco::Model" do
  
  it "should be defined" do
    Loco::Model.ancestors.member?(Loco::Observable).should.equal true
  end
  
  it "should return an instance of the model on #find" do
    show = Show.find(1)
    show.id.should.equal 1
    
    show = Show.find(2)
    show.id.should.equal 2
  end
  
end