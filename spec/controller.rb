describe "Loco::Controller" do
  
  it "should be defined" do
    Loco::Controller.ancestors.member?(Loco::Observable).should.equal true
  end
  
end