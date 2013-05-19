describe "Loco Views" do
  
  describe "- Loco::Button" do
    it "should be defined" do
      Loco::Button.ancestors.member?(UIButton).should.equal true
      Loco::Button.ancestors.member?(Loco::Observable).should.equal true
      Loco::Button.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::DatePicker" do
    it "should be defined" do
      Loco::DatePicker.ancestors.member?(UIDatePicker).should.equal true
      Loco::DatePicker.ancestors.member?(Loco::Observable).should.equal true
      Loco::DatePicker.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::ImageView" do
    it "should be defined" do
      Loco::ImageView.ancestors.member?(UIImageView).should.equal true
      Loco::ImageView.ancestors.member?(Loco::Observable).should.equal true
      Loco::ImageView.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::Label" do
    it "should be defined" do
      Loco::Label.ancestors.member?(UILabel).should.equal true
      Loco::Label.ancestors.member?(Loco::Observable).should.equal true
      Loco::Label.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::PickerView" do
    it "should be defined" do
      Loco::PickerView.ancestors.member?(UIPickerView).should.equal true
      Loco::PickerView.ancestors.member?(Loco::Observable).should.equal true
      Loco::PickerView.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::ProgressView" do
    it "should be defined" do
      Loco::ProgressView.ancestors.member?(UIProgressView).should.equal true
      Loco::ProgressView.ancestors.member?(Loco::Observable).should.equal true
      Loco::ProgressView.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::ScrollView" do
    it "should be defined" do
      Loco::ScrollView.ancestors.member?(UIScrollView).should.equal true
      Loco::ScrollView.ancestors.member?(Loco::Observable).should.equal true
      Loco::ScrollView.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::Slider" do
    it "should be defined" do
      Loco::Slider.ancestors.member?(UISlider).should.equal true
      Loco::Slider.ancestors.member?(Loco::Observable).should.equal true
      Loco::Slider.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::TextView" do
    it "should be defined" do
      Loco::TextView.ancestors.member?(UITextView).should.equal true
      Loco::TextView.ancestors.member?(Loco::Observable).should.equal true
      Loco::TextView.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::Toolbar" do
    it "should be defined" do
      Loco::Toolbar.ancestors.member?(UIToolbar).should.equal true
      Loco::Toolbar.ancestors.member?(Loco::Observable).should.equal true
      Loco::Toolbar.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::View" do
    it "should be defined" do
      Loco::View.ancestors.member?(UIView).should.equal true
      Loco::View.ancestors.member?(Loco::Observable).should.equal true
      Loco::View.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::WebView" do
    it "should be defined" do
      Loco::WebView.ancestors.member?(UIWebView).should.equal true
      Loco::WebView.ancestors.member?(Loco::Observable).should.equal true
      Loco::WebView.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
end