class CellItem < Loco::Model
  property :title
end

class ItemsController < Loco::Controller
  property :content
end

describe "Loco::UI::TableViewCell" do
  
  it "should be defined" do
    Loco::UI::TableViewCell.ancestors.member?(UITableViewCell).should.equal true
    Loco::UI::TableViewCell.ancestors.member?(Loco::Observable).should.equal true
  end
  
  it "should accept a Loco::Model as content" do
    @item = CellItem.new(title: 'RubyMotion')
    @cell = Loco::UI::TableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'CELL_ID')  
    @cell.content = @item
    @cell.content.title.should.equal 'RubyMotion'
  end
  
end

describe "Loco::UI::TableView" do
  
  it "should be defined" do
    Loco::UI::TableView.ancestors.member?(UITableView).should.equal true
    Loco::UI::TableView.ancestors.member?(Loco::Observable).should.equal true
    Loco::UI::TableView.ancestors.member?(Loco::Resizable).should.equal true
  end
  
  it "should accept an array of objects as content" do
    @items = [CellItem.new(title: 'iOS'), CellItem.new(title: 'RubyMotion')]
    @table_view = Loco::UI::TableView.alloc.initWithFrame(
      bottom: 0,
      left: 0,
      right: 0,
      top: 0
    )
    @table_view.content.should.equal nil
    
    @table_view.content = @items
    @table_view.content.length.should.equal 2
    @table_view.content.first.title.should.equal 'iOS'
    @table_view.content.last.title.should.equal 'RubyMotion'
  end
  
  it "should be able to bind its content to a Loco::Controller" do
    @items = [CellItem.new(title: 'Bound'), CellItem.new(title: 'Items')]
    @table_view = Loco::UI::TableView.alloc.initWithFrame(
      content_binding: 'ItemsController.content',
      bottom: 0,
      left: 0,
      right: 0,
      top: 0
    )
    @table_view.content.should.equal nil
    
    ItemsController.content = @items
    @table_view.content.length.should.equal 2
    @table_view.content.first.title.should.equal 'Bound'
    @table_view.content.last.title.should.equal 'Items'
  end
  
  it "should have an item class" do
    @table_view = Loco::UI::TableView.alloc.initWithFrame(
      bottom: 0,
      left: 0,
      right: 0,
      top: 0
    )
    @table_view.item_view_class.should.equal Loco::UI::TableViewCell
  end

  # TODO: Test each cell once I figure out how to make it think the cell is visible
  # it "should assign each item to a table view cell" do
  #   @items = [CellItem.new(title: 'iOS'), CellItem.new(title: 'RubyMotion')]
  #   @table_view = Loco::UI::TableView.alloc.initWithFrame(
  #     content: @items,
  #     bottom: 0,
  #     left: 0,
  #     right: 0,
  #     top: 0
  #   )
  #   
  #   @table_view.numberOfSections.should.equal 1
  #   @table_view.numberOfRowsInSection(0).should.equal 2
  #   
  #   
  #   
  #   @cell = @table_view.cellForRowAtIndexPath(NSIndexPath.indexPathForRow(0, inSection:0))
  #   @cell.content.title.should.equal 'iOS'
  #   
  #   @cell = @table_view.cellForRowAtIndexPath(NSIndexPath.indexPathForRow(1, inSection:0))
  #   @cell.content.title.should.equal 'RubyMotion'
  # end
  
end