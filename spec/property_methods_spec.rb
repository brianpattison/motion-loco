describe "Loco" do
  describe "- Property Methods" do
    
    before do
      @label = UILabel.alloc.initWithFrame([[0, 0], [100, 100]])
    end
    
    it "should get the value of Objective-C properties from an object" do
      @label.text = "Hello World"
      Loco.get(@label, :text).should.equal "Hello World"
    end
    
    it "should set the value of Objective-C properties on an object" do
      Loco.set(@label, :text, "Hello World")
      @label.text.should.equal "Hello World"
    end
    
    it "should accept underscore and camelized property names" do
      Loco.set(@label, :highlighted_text_color, UIColor.blueColor)
      @label.highlightedTextColor.should.equal UIColor.blueColor

      @label.highlightedTextColor =  UIColor.redColor
      Loco.get(@label, :highlighted_text_color).should.equal UIColor.redColor
      
      Loco.set(@label, :highlightedTextColor, UIColor.blueColor)
      @label.highlightedTextColor.should.equal UIColor.blueColor

      @label.highlightedTextColor =  UIColor.redColor
      Loco.get(@label, :highlightedTextColor).should.equal UIColor.redColor
    end
    
    it "should get the value of chained Objective-C properties" do
      @button = UIBarButtonItem.alloc.initWithTitle("Hello World", style:UIBarButtonItemStylePlain, target:self, action:'tap:')
      
    end
    
    it "should set the value of chained Objective-C properties" do
    end
    
  end
end