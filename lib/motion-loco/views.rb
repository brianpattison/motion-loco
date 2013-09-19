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
      
      def text_align
        case self.textAlignment
        when NSTextAlignmentLeft
          'left'
        when NSTextAlignmentCenter
          'center'
        when NSTextAlignmentRight
          'right'
        when NSTextAlignmentJustified
          'justified'
        when NSTextAlignmentNatural
          'natural'
        end
      end
      alias_method :textAlign, :text_align
      
      def text_align=(alignment)
        case alignment
        when 'left'
          self.textAlignment = NSTextAlignmentLeft
        when 'center'
          self.textAlignment = NSTextAlignmentCenter
        when 'right'
          self.textAlignment = NSTextAlignmentRight
        when 'justified'
          self.textAlignment = NSTextAlignmentJustified
        when 'natural'
          self.textAlignment = NSTextAlignmentNatural
        end
      end
      alias_method :textAlign=, :text_align=
      
      def textAlignment=(alignment)
        if alignment.is_a? String
          self.text_align = alignment
        else
          super
        end
      end
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