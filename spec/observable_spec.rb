describe "Loco::Observable" do
  describe "- Loco::Observable Module" do
    it "should be defined" do
      Loco::Observable.class.should.equal Module
    end
  end
  
  describe "- Loco::Observable Model" do
    
    it "should include Loco::Observable" do
      class ObservableModel
        include Loco::Observable
      end
      ObservableModel.ancestors.member?(Loco::Observable).should.equal true
    end
    
  end
end