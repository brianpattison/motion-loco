describe "Loco::FixtureAdapter" do
  
  it "should be defined" do
    Loco::RESTAdapter.ancestors.member?(Loco::Adapter).should.equal true
  end
  
  it "should accept a block on #find and the loaded record should be returned" do
    post = Post.find(1) do |loaded_post|
      
    end
    
    comment = Comment.find(1) do |loaded_comment|
      
    end
  end
  
  it "should return an array of all records for a model using #find without an id" do
    posts = Post.find do |loaded_posts|
      
    end
    
    comments = Comment.find do |loaded_comments|
      
    end
  end
  
  it "should return an array of records from multiple ids" do
    posts = Post.find([1, 2]) do |loaded_posts|
      
    end
    
    comments = Comment.find([2, 3, 5]) do |loaded_comments|
      
    end
  end
  
  it "should return an array of all records matching parameters given as a Hash" do
    comments = Comment.find(post_id: 1) do |loaded_comments|
      
    end
    
    comments = Comment.find(post_id: 2) do |loaded_comments|
      
    end
  end
  
end