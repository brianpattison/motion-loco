motion_require 'observable'
motion_require 'resizable'

module Loco
  
  module UI
  
    class Button < UIButton
      include Resizable
    end
  
    class DatePicker < UIDatePicker
      include Resizable
    end
  
    class ImageView < UIImageView
      include Resizable
    end
    
    class Label < UILabel
      include Resizable
      include TextAlignable
    end
    
    class PageControl < UIPageControl
      include Resizable
    end
  
    class PickerView < UIPickerView
      include Resizable
    end
  
    class ProgressView < UIProgressView
      include Resizable
    end
  
    class ScrollView < UIScrollView
      include Resizable
    end
  
    class Slider < UISlider
      include Resizable
    end
    
    class TableView < UITableView
      include Resizable
    end
    
    class TextField < UITextField
      include Resizable
      include TextAlignable
    end
  
    class TextView < UITextView
      include Resizable
    end
  
    class Toolbar < UIToolbar
      include Resizable
    end
  
    class View < UIView
      include Resizable
      
      def border_radius
        self.layer.cornerRadius
      end
      alias_method :borderRadius, :border_radius
      
      def border_radius=(radius)
        self.layer.cornerRadius = radius
      end
      alias_method :borderRadius=, :border_radius=
    end
  
    class WebView < UIWebView
      include Resizable
    end
    
  end
  
end