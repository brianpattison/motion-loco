describe "Loco Views" do
  
  describe "- Loco::UI::Button" do
    it "should be defined" do
      Loco::UI::Button.ancestors.member?(UIButton).should.equal true
      Loco::UI::Button.ancestors.member?(Loco::Observable).should.equal true
      Loco::UI::Button.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::UI::DatePicker" do
    it "should be defined" do
      Loco::UI::DatePicker.ancestors.member?(UIDatePicker).should.equal true
      Loco::UI::DatePicker.ancestors.member?(Loco::Observable).should.equal true
      Loco::UI::DatePicker.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::UI::ImageView" do
    it "should be defined" do
      Loco::UI::ImageView.ancestors.member?(UIImageView).should.equal true
      Loco::UI::ImageView.ancestors.member?(Loco::Observable).should.equal true
      Loco::UI::ImageView.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::UI::Label" do
    it "should be defined" do
      Loco::UI::Label.ancestors.member?(UILabel).should.equal true
      Loco::UI::Label.ancestors.member?(Loco::Observable).should.equal true
      Loco::UI::Label.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::UI::PickerView" do
    it "should be defined" do
      Loco::UI::PickerView.ancestors.member?(UIPickerView).should.equal true
      Loco::UI::PickerView.ancestors.member?(Loco::Observable).should.equal true
      Loco::UI::PickerView.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::UI::ProgressView" do
    it "should be defined" do
      Loco::UI::ProgressView.ancestors.member?(UIProgressView).should.equal true
      Loco::UI::ProgressView.ancestors.member?(Loco::Observable).should.equal true
      Loco::UI::ProgressView.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::UI::ScrollView" do
    it "should be defined" do
      Loco::UI::ScrollView.ancestors.member?(UIScrollView).should.equal true
      Loco::UI::ScrollView.ancestors.member?(Loco::Observable).should.equal true
      Loco::UI::ScrollView.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::UI::Slider" do
    it "should be defined" do
      Loco::UI::Slider.ancestors.member?(UISlider).should.equal true
      Loco::UI::Slider.ancestors.member?(Loco::Observable).should.equal true
      Loco::UI::Slider.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::UI::TextView" do
    it "should be defined" do
      Loco::UI::TextView.ancestors.member?(UITextView).should.equal true
      Loco::UI::TextView.ancestors.member?(Loco::Observable).should.equal true
      Loco::UI::TextView.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::UI::Toolbar" do
    it "should be defined" do
      Loco::UI::Toolbar.ancestors.member?(UIToolbar).should.equal true
      Loco::UI::Toolbar.ancestors.member?(Loco::Observable).should.equal true
      Loco::UI::Toolbar.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::UI::View" do
    it "should be defined" do
      Loco::UI::View.ancestors.member?(UIView).should.equal true
      Loco::UI::View.ancestors.member?(Loco::Observable).should.equal true
      Loco::UI::View.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
  describe "- Loco::UI::WebView" do
    it "should be defined" do
      Loco::UI::WebView.ancestors.member?(UIWebView).should.equal true
      Loco::UI::WebView.ancestors.member?(Loco::Observable).should.equal true
      Loco::UI::WebView.ancestors.member?(Loco::Resizable).should.equal true
    end
  end
  
end