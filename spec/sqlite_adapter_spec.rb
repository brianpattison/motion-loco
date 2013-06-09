describe "Loco::SQLiteAdapter" do
  
  it "should be defined" do
    Loco::SQLiteAdapter.ancestors.member?(Loco::Adapter).should.equal true
  end
  
end