describe "Loco::RESTAdapter" do
  
  it "should be defined" do
    Loco::RESTAdapter.ancestors.member?(Loco::Adapter).should.equal true
  end
  
  it "should accept a base URL on initialize" do
    @adapter = Loco::RESTAdapter.new('http://localhost:3000/')
    @adapter.url.should.equal 'http://localhost:3000'
  end
  
  it "should raise an error if you don't specify the base URL" do
    should.raise ArgumentError do
      @adapter = Loco::RESTAdapter.new
      @adapter.url
    end
  end
  
  it "should accept a block on #find and the loaded record should be returned" do
    @post = Post.find(1) do |post|
      resume
    end
    
    wait do
      @post.title.should.equal "My first blog post"
    end
  end
  
  it "should change the URL route based on the model's class name" do
    @comment = Comment.find(1) do |comment|
      resume
    end
    
    wait do
      @comment.body.should.equal "I love Ruby and iOS!"
    end
  end
  
  it "should return an array of all records for a model using #all" do
    @posts = Post.all do |posts|
      resume
    end
    
    wait do
      @posts.length.should.equal 2
    end
  end
  
  it "should return an array of records from multiple ids" do
    @comments = Comment.find([2, 3, 5]) do |comments|
      resume
    end
    
    wait do
      @comments.length.should.equal 3
      @comments.first.body.should.equal "Just use Objective-C!"
      @comments.last.body.should.equal "What's a Rails app doing in a RubyMotion gem repo??"
    end
  end
  
  it "should return an array of all records matching parameters given as a Hash" do
    @comments = Comment.where(post_id: 2) do |comments|
      resume
    end
    
    wait do
      @comments.length.should.equal 3
      @comments.first.body.should.equal "Yay! A REST data adapter!"
      @comments.last.body.should.equal "I do what I want!"
    end
  end
  
  it "should save a new record and assign the ID back to the record" do
    @post = Post.new(title: "Loco::RESTAdapter can save!", body: "Hopefully.")
    @post.save do |post|
      resume
    end
    
    @post.id.nil?.should.equal true
    
    wait do
      @post.id.nil?.should.equal false
    end
  end
  
end