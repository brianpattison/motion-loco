module Loco
  
  module Resizable
    attr_accessor :parent_view
    alias_method :parentView, :parent_view
    alias_method :parentView=, :parent_view=
    
    # The position of the bottom edge,
    # relative to the superview's bottom edge.
    # @return [Integer]
    attr_accessor :bottom
    def bottom=(bottom)
      super
      refresh_layout
    end
    
    # The height of the view.
    # @return [Integer]
    attr_accessor :height
    def height=(height)
      super
      refresh_layout
    end
    
    # The position of the left edge,
    # relative to the superview's left edge.
    # @return [Integer]
    attr_accessor :left
    def left=(left)
      super
      refresh_layout
    end
    
    # The position of the right edge,
    # relative to the superview's right edge.
    # @return [Integer]
    attr_accessor :right
    def right=(right)
      super
      refresh_layout
    end
    
    # The position of the top edge,
    # relative to the superview's top edge.
    # @return [Integer]
    attr_accessor :top
    def top=(top)
      super
      refresh_layout
    end
    
    # The width of the view.
    # @return [Integer]
    attr_accessor :width
    def width=(width)
      super
      refresh_layout
    end
    
    # Create new instance from a hash of properties with values.
    # @param [Object] frame The CGRect or a Hash of properties.
    def initWithFrame(frame)
      if frame.is_a? Hash
        # Set the initial property values from the given hash
        super(CGRect.new)
        frame.each do |key, value|
          self.send("#{key}=", value)
        end
      else
        super(frame)
      end
      view_setup
      self
    end
    
    # Refresh the layout based on bottom, left, right, top, and superview.
    # @param [UIView] superview
    def refresh_layout(superview=nil)
      # The view can't be positioned without being added to the superview first.
      superview ||= self.superview
      return if superview.nil?

      # Determine the original size, position, and autoresizing mask that should be used.
      if self.top && self.bottom
        if self.left && self.right
          # FW, FH
          @origin_x     = self.left
          @origin_y     = self.top
          @size_height  = superview.bounds.size.height - self.top - self.bottom
          @size_width   = superview.bounds.size.width - self.left - self.right
          @autoresizing = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
        elsif self.left && self.width
          # FH, FRM
          @origin_x     = self.left
          @origin_y     = self.top
          @size_height  = superview.bounds.size.height - self.top - self.bottom
          @size_width   = self.width
          @autoresizing = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin
        elsif self.right && self.width
          # FH, FLM
          @origin_x     = superview.bounds.size.width - self.width - self.right
          @origin_y     = self.top
          @size_height  = superview.bounds.size.height - self.top - self.bottom
          @size_width   = self.width
          @autoresizing = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin
        elsif self.width
          # FH, FLM, FRM
          @origin_x     = (superview.bounds.size.width - self.width) / 2
          @origin_y     = self.top
          @size_height  = superview.bounds.size.height - self.top - self.bottom
          @size_width   = self.width
          @autoresizing = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
        else
          # Needs More Params
          NSLog('%@<Loco::View> Not enough params to position and size the view.', self.class)
        end
      elsif self.top
        if self.left && self.right && self.height
          # FW, FBM
          @origin_x     = self.left
          @origin_y     = self.top
          @size_height  = self.height
          @size_width   = superview.bounds.size.width - self.left - self.right
          @autoresizing = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin
        elsif self.left && self.height && self.width
          # FBM, FRM
          @origin_x     = self.left
          @origin_y     = self.top
          @size_height  = self.height
          @size_width   = self.width
          @autoresizing = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin
        elsif self.right && self.height && self.width
          # FBM, FLM
          @origin_x     = superview.bounds.size.width - self.width - self.right
          @origin_y     = self.top
          @size_height  = self.height
          @size_width   = self.width
          @autoresizing = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin
        elsif self.height && self.width
          # FLM, FRM, FBM
          @origin_x     = (superview.bounds.size.width - self.width) / 2
          @origin_y     = self.top
          @size_height  = self.height
          @size_width   = self.width
          @autoresizing = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleBottomMargin
        else
          # Needs More Params
          NSLog('%@<Loco::View> Not enough params to position and size the view.', self.class)
        end
      elsif self.bottom
        if self.left && self.right && self.height
          # FW, FTM
          @origin_x     = self.left
          @origin_y     = superview.bounds.size.height - self.height - self.bottom
          @size_height  = self.height
          @size_width   = superview.bounds.size.width - self.left - self.right
          @autoresizing = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin
        elsif self.left && self.height && self.width
          # FTM, FRM
          @origin_x     = self.left
          @origin_y     = superview.bounds.size.height - self.height - self.bottom
          @size_height  = self.height
          @size_width   = self.width
          @autoresizing = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin
        elsif self.right && self.height && self.width
          # FTM, FLM
          @origin_x     = superview.bounds.size.width - self.width - self.right
          @origin_y     = superview.bounds.size.height - self.height - self.bottom
          @size_height  = self.height
          @size_width   = self.width
          @autoresizing = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin
        elsif self.height && self.width
          # FLM, FRM, FTM
          @origin_x     = (superview.bounds.size.width - self.width) / 2
          @origin_y     = superview.bounds.size.height - self.height - self.bottom
          @size_height  = self.height
          @size_width   = self.width
          @autoresizing = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin
        else
          # Needs More Params
          NSLog('%@<Loco::View> Not enough params to position and size the view.', self.class)
        end
      elsif self.left && self.right && self.height
        # FW, FTM, FBM
        @origin_x     = self.left
        @origin_y     = (superview.bounds.size.height - self.height) / 2
        @size_height  = self.height
        @size_width   = superview.bounds.size.width - self.left - self.right
        @autoresizing = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
      elsif self.width && self.height
        if self.left
          # FTM, FBM, FRM
          @origin_x     = self.left
          @origin_y     = (superview.bounds.size.height - self.height) / 2
          @size_height  = self.height
          @size_width   = self.width
          @autoresizing = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin
        elsif self.right
          # FTM, FBM, FLM
          @origin_x     = superview.bounds.size.width - self.width - self.right
          @origin_y     = (superview.bounds.size.height - self.height) / 2
          @size_height  = self.height
          @size_width   = self.width
          @autoresizing = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin
        else
          # FTM, FBM, FLM, FRM
          @origin_x     = (superview.bounds.size.width - self.width) / 2
          @origin_y     = (superview.bounds.size.height - self.height) / 2
          @size_height  = self.height
          @size_width   = self.width
          @autoresizing = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
        end
      else
        # Needs More Params
        NSLog('%@<Loco::View> Not enough params to position and size the view.', self.class)
      end
      
      # Warn of any possible conflicts
      if self.top && self.bottom && self.height
        NSLog('%@<Loco::View> `top`, `bottom`, and `height` may conflict with each other. Only two of the three should be set.', self.class)
        NSLog('%@<Loco::View> top: %@, bottom: %@, height: %@', self.class, self.top, self.bottom, self.height)
      end
      if self.left && self.right && self.width
        NSLog('%@<Loco::View> `left`, `right`, and `width` may conflict with each other. Only two of the three should be set.', self.class)
        NSLog('%@<Loco::View> left: %@, right: %@, width: %@', self.class, self.left, self.right, self.width)
      end
      
      if @origin_x && @origin_y && @size_width && @size_height && @autoresizing
        self.frame = [[@origin_x, @origin_y], [@size_width, @size_height]]
        self.autoresizingMask = @autoresizing
      end
      
      # Update the subviews
      self.subviews.each do |view|
        view.refresh_layout(self) if view.is_a? Resizable
      end
    end
    
    def view_setup
      viewSetup
    end
    
    def viewSetup
      # Override #view_setup or #viewSetup to customize the view
    end
    
    # Fires when the superview changes.
    def willMoveToSuperview(superview)
      self.parentView = superview
      refresh_layout(superview)
    end
  end
  
end