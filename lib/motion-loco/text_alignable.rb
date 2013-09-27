module Loco
  
  module TextAlignable
    
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
  
end