describe "Loco::SQLiteAdapter" do
  
  it "should be defined" do
    Loco::SQLiteAdapter.ancestors.member?(Loco::Adapter).should.equal true
  end
  
  it "should pass all adapter tests" do
    AdapterTestHelper.run('Loco::SQLiteAdapter').should.equal true
  end
  
end