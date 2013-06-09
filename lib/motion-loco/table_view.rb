motion_require 'observable'
motion_require 'resizable'

module Loco
  
  module UI
  
    class TableViewCell < UITableViewCell
      include Observable
    
      property :content
    
      def initWithStyle(style, reuseIdentifier:reuseIdentifier)
        if super
          view_setup # Needed because it's not Loco::Resizable
        end
        self
      end
    
      def select
        Loco.debug("Override #{self.class}#select with the action to take when the row is selected")
      end
    
      def view_controller(superview=nil)
        if superview
          view_controller = superview.nextResponder
        else
          view_controller = self.superview.nextResponder
        end
        if view_controller.is_a? UIViewController
          view_controller
        elsif view_controller.is_a? UIView
          self.view_controller(view_controller)
        end
      end
      alias_method :viewController, :view_controller
    
      def view_setup
        viewSetup
      end
    
      def viewSetup
        Loco.debug("Override #{self.class}#viewSetup or #{self.class}#view_setup to customize the view")
      end
    end
  
    class TableView < UITableView
      include Resizable
      include Observable
    
      property :content
    
      def content=(value)
        super
        self.reloadData
      end
    
      def cell_id
        @cell_id ||= "CELL_#{self.object_id}"
      end
    
      def initWithFrame(frame)
        super(frame)
        self.dataSource = self.delegate = self
      end
      
      def item_view_class
        self.class.get_item_view_class
      end
      
      # UITableViewDelegate implementation for returning the cell at a given indexPath.
      # @return [Loco::TableViewCell]
      def tableView(tableView, cellForRowAtIndexPath:indexPath)
        cell = tableView.dequeueReusableCellWithIdentifier(cell_id) 
        unless cell
          cell = self.item_view_class.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:cell_id)
        end
        cell.content = self.content[indexPath.row]
        cell
      end
    
      # UITableViewDelegate implementation for selecting a cell at a given indexPath.
      def tableView(tableView, didSelectRowAtIndexPath:indexPath)
        cell = tableView.cellForRowAtIndexPath(indexPath)
        cell.select
      end
    
      # UITableViewDelegate implementation for returning the number of rows in a section.
      # @return [Integer]
      def tableView(tableView, numberOfRowsInSection:section)
        if self.content.is_a? Array
          self.content.length
        else
          0
        end
      end
    
      class << self
      
        def item_view_class(view_class)
          @item_view_class = view_class
        end
        alias_method :itemViewClass, :item_view_class
      
        def get_item_view_class
          @item_view_class ||= TableViewCell
        end
      
      end
    end
    
  end
  
end
