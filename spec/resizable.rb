describe "Loco::Resizable" do
  describe "- Loco::Resizable Module" do
    it "should be defined" do
      Loco::Resizable.class.should.equal Module
    end
  end
  
  describe "- Loco::Resizable View" do
    before do
      # Create a Loco::Resizable view class.
      class ResizableView < UIView
        include Loco::Resizable
      end
    end
    
    it "should be a UIView" do
      ResizableView.ancestors.member?(UIView).should.equal true
    end
    
    it "should include Loco::Resizable Module" do
      ResizableView.ancestors.member?(Loco::Resizable).should.equal true
    end
    
    it "accepts an Array on #initWithFrame" do
      should.not.raise(TypeError) {
        @view = ResizableView.alloc.initWithFrame([[0, 0], [100, 100]])
      }
    end
    
    it "accepts a CGRect on #initWithFrame" do
      should.not.raise(TypeError) {
        @view = ResizableView.alloc.initWithFrame(CGRectMake(0, 0, 100, 100))
      }
    end
    
    it "accepts a Hash on #initWithFrame" do
      should.not.raise(TypeError) {
        @view = ResizableView.alloc.initWithFrame(
          height: 100,
          width: 100
        )
      }
    end
    
    it "responds to size and position properties" do
      %w(bottom height left right top width).each{|property|
        @view.respond_to?(property).should.equal true
      }
    end
    
    it "should not set the frame until moving to a subview" do
      @child_view = ResizableView.alloc.initWithFrame(
        height: 50,
        width: 50
      )
      @child_view.frame.should.equal(CGRect.new)
    end
    
    it "should resize the frame after moving to a subview" do
      @parent_view = ResizableView.alloc.initWithFrame([[0, 0], [100, 100]])
      @parent_view.addSubview(@child_view)
      @child_view.frame.size.height.should.equal 50
      @child_view.frame.size.width.should.equal 50
    end
    
    it "should resize the child views after moving to a subview" do
      @top_view = ResizableView.alloc.initWithFrame([[0, 0], [200, 300]])
      @parent_view = ResizableView.alloc.initWithFrame(
        bottom: 10,
        left: 10,
        right: 10,
        top: 10
      )
      @first_child_view = ResizableView.alloc.initWithFrame(
        bottom: 10,
        left: 10,
        right: 10,
        top: 10
      )
      @parent_view.addSubview(@first_child_view)
      @second_child_view = ResizableView.alloc.initWithFrame(
        bottom: 10,
        left: 10,
        right: 10,
        top: 10
      )
      @first_child_view.addSubview(@second_child_view)
      
      @top_view.addSubview(@parent_view)
      
      @parent_view.frame.origin.x.should.equal 10
      @parent_view.frame.origin.y.should.equal 10
      @parent_view.frame.size.width.should.equal 180
      @parent_view.frame.size.height.should.equal 280
      
      @first_child_view.frame.origin.x.should.equal 10
      @first_child_view.frame.origin.y.should.equal 10
      @first_child_view.frame.size.width.should.equal 160
      @first_child_view.frame.size.height.should.equal 260
      
      @second_child_view.frame.origin.x.should.equal 10
      @second_child_view.frame.origin.y.should.equal 10
      @second_child_view.frame.size.width.should.equal 140
      @second_child_view.frame.size.height.should.equal 240
    end
    
  end
end