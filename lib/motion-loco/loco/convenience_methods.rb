module Loco
  
  # TODO: Determine if logging should happen based on environment
  def self.debug(obj)
    ap obj
  end
  
  def self.t(name, *args)
    if args
      format = NSBundle.mainBundle.localizedStringForKey(name, value:nil, table:nil)
      format % args
    else
      NSBundle.mainBundle.localizedStringForKey(name, value:nil, table:nil)
    end
  end
  
end