describe "Loco::FixtureAdapter" do
  
  it "should be defined" do
    Loco::FixtureAdapter.ancestors.member?(Loco::Adapter).should.equal true
  end
  
end