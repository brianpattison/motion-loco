motion_require 'observable'
motion_require 'resizable'

module Loco
  
  module UI
  
    class Button < UIButton
      include Resizable
      include Observable
    end
  
    class DatePicker < UIDatePicker
      include Resizable
      include Observable
    end
  
    class ImageView < UIImageView
      include Resizable
      include Observable
    end
    
    class Label < UILabel
      include Resizable
      include Observable
    end
  
    class PickerView < UIPickerView
      include Resizable
      include Observable
    end
  
    class ProgressView < UIProgressView
      include Resizable
      include Observable
    end
  
    class ScrollView < UIScrollView
      include Resizable
      include Observable
    end
  
    class Slider < UISlider
      include Resizable
      include Observable
    end
  
    class TextView < UITextView
      include Resizable
      include Observable
    end
  
    class Toolbar < UIToolbar
      include Resizable
      include Observable
    end
  
    class View < UIView
      include Resizable
      include Observable
    end
  
    class WebView < UIWebView
      include Resizable
      include Observable
    end
    
  end
  
end