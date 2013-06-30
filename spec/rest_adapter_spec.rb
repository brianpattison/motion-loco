motion_require 'adapter_test_helper'

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
  
  it "should pass all adapter tests" do
    AdapterTestHelper.run('Loco::RESTAdapter', { async: true }, 'http://localhost:3000').should.equal true
  end
  
  # it "should serialize the belongs_to id" do
  #   @post = Post.find(1)
  #   @comment = Comment.new(post: @post)
  #   @comment.post_id.should.equal 1
  #   @comment.serialize(root: false)[:post_id].should.equal 1
  # end
  # 
  # it "should serialize the has_many ids" do
  #   @post = Post.new
  #   @post.comments = Comment.find([3, 4, 5])
  #   @post.serialize(root: false)[:comment_ids].should.equal [3, 4, 5]
  # end
end