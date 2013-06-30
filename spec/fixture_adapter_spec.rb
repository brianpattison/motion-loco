describe "Loco::FixtureAdapter" do
  
  it "should be defined" do
    Loco::FixtureAdapter.ancestors.member?(Loco::Adapter).should.equal true
  end
  
  it "should pass all adapter tests" do
    AdapterTestHelper.run('Loco::FixtureAdapter', { readonly: true }, 'http://localhost:3000').should.equal true
  end
  
end