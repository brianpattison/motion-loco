class AdapterTestHelper
  
  def self.run(adapter, options={}, *args)
    
    # Some of the tests are duplicates, but useful for testing
    # finds with queries and multiple ids. Might as well test
    # every time we create data used for the next tests.
    
    describe "Loco::Adapter Tests - #{adapter}" do
      if options[:async]
        @wait_for = nil
      else
        @wait_for = 0.01
      end
      
      it "should assign the adapter to the model with optional arguments" do
        should.not.raise(NoMethodError, TypeError) do
          Comment.adapter(adapter, *args)
          Post.adapter(adapter, *args)
        end
      end
      
      ##### Record Saving
      
      if options[:readonly]
        
        @saved_post_id = 1
        @saved_post_id_confirm = 2
        
      else
      
        it "should save a new record and assign the ID back to the record" do
          @post = Post.new(title: "Loco::Adapter Tests", body: "Use the AdapterTestHelper to test your data adapter.")
          @post.id.nil?.should.equal true
        
          @post.save do |post|
            resume if @wait_for.nil?
          end
  
          wait @wait_for do
            @saved_post_id = @post.id
            @saved_post_id.nil?.should.equal false
          end
        end
    
        it "should save another record for testing stuff" do
          @post_confirm = Post.new(title: "Another Post for Testing", body: "Making sure the tests aren't just getting lucky.")
          @post_confirm.id.nil?.should.equal true
      
          @post_confirm.save do |post|
            resume if @wait_for.nil?
          end
  
          wait @wait_for do
            @saved_post_id_confirm = @post_confirm.id
            @saved_post_id_confirm.nil?.should.equal false
          end
        end
        
      end
      
      ##### Record Loading
      
      it "should return a Loco::RecordArray on #all" do
        @posts = Post.all
        @posts.is_a?(Loco::RecordArray).should.equal true
      end
  
      it "should return a Loco::RecordArray on #where" do
        @posts = Post.where(title: "Loco::Adapter Tests")
        @posts.is_a?(Loco::RecordArray).should.equal true
      end
    
      it "should accept a block on #find and the loaded record should be returned" do
        @post = Post.find(@saved_post_id) do |post|
          resume if @wait_for.nil?
        end
  
        wait @wait_for do
          @post.title.should.equal "Loco::Adapter Tests"
        end
      end
    
      it "should load the additional record as well" do
        @post_confirm = Post.find(@saved_post_id_confirm) do |post|
          resume if @wait_for.nil?
        end

        wait @wait_for do
          @post_confirm.title.should.equal "Another Post for Testing"
        end
      end
    
      it "should return an array of all records for a model using #all" do
        @posts = Post.all do |posts|
          resume if @wait_for.nil?
        end
        
        wait @wait_for do
          @posts.length.should.equal 2
        end
      end
      
      it "should return an array of records from multiple ids" do
        @posts = Post.find([@saved_post_id, @saved_post_id_confirm]) do |posts|
          resume if @wait_for.nil?
        end
        
        wait @wait_for do
          @posts.length.should.equal 2
          @posts.first.title.should.equal "Loco::Adapter Tests"
          @posts.last.title.should.equal "Another Post for Testing"
        
          @posts = Post.find([@saved_post_id_confirm]) do |posts|
            resume if @wait_for.nil?
          end
        
          wait @wait_for do
            @posts.length.should.equal 1
            @posts.first.title.should.equal "Another Post for Testing"
          end
        end
      end
      
      ##### Record Serialization
      
      it "should include the root on serialization" do
        @post = Post.find(@saved_post_id) do |post|
          resume if @wait_for.nil?
        end
  
        wait @wait_for do
          @hash = @post.serialize
          @hash[:post].nil?.should.equal false
        end
      end
  
      it "should accept an option to not include root" do
        @post = Post.find(@saved_post_id) do |post|
          resume if @wait_for.nil?
        end
  
        wait @wait_for do
          @hash = @post.serialize(root: false)
          @hash[:post].nil?.should.equal true
        end
      end
  
      it "should accept an option to change the root used" do
        @post = Post.find(@saved_post_id) do |post|
          resume if @wait_for.nil?
        end
  
        wait @wait_for do
          @hash = @post.serialize(root: 'blog_post')
          @hash[:blog_post].nil?.should.equal false
        end
      end
      
      it "should accept option to include id on serialization" do
        @post = Post.find(@saved_post_id) do |post|
          resume if @wait_for.nil?
        end
  
        wait @wait_for do
          @hash = @post.serialize(include_id: true)
          @hash[:post][:id].should.equal @saved_post_id
        end
      end
      
      it "should use data transforms on serialization" do
        @post = Post.new(title: 1000)
        @hash = @post.serialize
        @hash[:post][:title].should.equal '1000'
      end
      
      ##### Belongs To Relationships
      
      if options[:readonly]
        
        @saved_comment_id = 1
        @saved_comment_id_confirm = 2
        
      else
    
        it "should save a belongs_to relationship" do
          @post = Post.find(@saved_post_id) do |post|
            resume if @wait_for.nil?
          end
      
          wait @wait_for do
            @comment = Comment.new(body: "Testing, testing, testing.", post: @post)
            @comment.save do |comment|
              resume if @wait_for.nil?
            end
        
            wait @wait_for do
              @saved_comment_id = @comment.id
              @comment.post_id.should.equal @saved_post_id
            end
          end
        end
    
        it "should save a belongs_to relationship again" do
          @post_confirm = Post.find(@saved_post_id_confirm) do |post|
            resume if @wait_for.nil?
          end
      
          wait @wait_for do
            @comment_confirm = Comment.new(body: "Testing again.", post: @post_confirm)
            @comment_confirm.save do |comment|
              resume if @wait_for.nil?
            end
        
            wait @wait_for do
              @saved_comment_id_confirm = @comment_confirm.id
              @comment_confirm.post_id.should.equal @saved_post_id_confirm
            end
          end
        end
        
      end
    
      it "should load a belongs_to id" do
        @comment = Comment.find(@saved_comment_id) do |comment|
          resume if @wait_for.nil?
        end
      
        wait @wait_for do
          @comment.post_id.should.equal @saved_post_id
        end
      end
    
      it "should load a belongs_to id again" do
        @comment_confirm = Comment.find(@saved_comment_id_confirm) do |comment|
          resume if @wait_for.nil?
        end
      
        wait @wait_for do
          @comment_confirm.post_id.should.equal @saved_post_id_confirm
        end
      end
    
      it "should load a belongs_to relationship when given a block" do
        @comment = Comment.find(@saved_comment_id) do |comment|
          resume if @wait_for.nil?
        end
      
        wait @wait_for do
          @comment.post do |post|
            resume if @wait_for.nil?
          end
        
          wait @wait_for do
            @comment.post.title.should.equal "Loco::Adapter Tests"
          end
        end
      end
      
      ##### Has Many Relationships
      
      if options[:readonly]
        
        @saved_comment_id_has_many = 3
        
      else
        
        it "should return a Loco::RecordArray for has_many relationships" do
          @post = Post.new
          @post.comments.is_a?(Loco::RecordArray).should.equal true
        end
    
        it "should save a has_many relationship" do
          @post = Post.find(@saved_post_id) do |post|
            post.comments do |comments|
              resume if @wait_for.nil?
            end
          end
      
          wait @wait_for do
            @comment = Comment.new(body: "Testing has_many relationships")
          
            @comment.save do |comment|
              resume if @wait_for.nil?
            end
          
            wait @wait_for do
              @saved_comment_id_has_many = @comment.id
              @post.comments << @comment
              
              @post.save do |post|
                resume if @wait_for.nil?
              end
            
              wait @wait_for do
                @post.comments.length.should.equal 2
                @post.comment_ids.length.should.equal 2
              end
            end
          end
        end
        
      end
    
      it "should load has_many ids" do
        @post = Post.find(@saved_post_id) do |post|
          resume if @wait_for.nil?
        end
      
        wait @wait_for do
          @post.comment_ids.length.should.equal 2
          @post.comment_ids.include?(@saved_comment_id_has_many).should.equal true
        end
      end
         
      it "should load a has_many relationship when given a block" do
        @post = Post.find(@saved_post_id) do |post|
          resume if @wait_for.nil?
        end
      
        wait @wait_for do
          @post.comments do |comments|
            resume if @wait_for.nil?
          end
        
          wait @wait_for do
            @post.comments.first.body.should.equal "Testing, testing, testing."
          end
        end
      end
      
      ##### Record Queries
  
      it "should return an array of all records matching parameters given as a Hash" do
        @comments = Comment.where(post_id: @saved_post_id) do |comments|
          resume if @wait_for.nil?
        end
        
        wait @wait_for do
          @comments.length.should.equal 2
          @comments.first.body.should.equal "Testing, testing, testing."
        end
      end
      
      ##### Record Deletion
      
      unless options[:readonly]

        it "should delete the saved post" do
          @post = Post.find(@saved_post_id) do |post|
            resume if @wait_for.nil?
          end
      
          wait @wait_for do
            @post.destroy do |post|
              resume if @wait_for.nil?
            end
        
            wait @wait_for do            
              @posts = Post.all do |posts|
                resume if @wait_for.nil?
              end
          
              wait @wait_for do
                @posts.length.should.equal 1
              end
            end
          end
        end
    
        it "should delete the other saved post" do
          @post = Post.find(@saved_post_id_confirm) do |post|
            resume if @wait_for.nil?
          end
      
          wait @wait_for do
            @post.destroy do |post|
              resume if @wait_for.nil?
            end
        
            wait @wait_for do            
              @posts = Post.all do |posts|
                resume if @wait_for.nil?
              end
          
              wait @wait_for do
                @posts.length.should.equal 0
              end
            end
          end
        end
    
        it "should delete the saved comment" do
          @comment = Comment.find(@saved_comment_id) do |comment|
            resume if @wait_for.nil?
          end
      
          wait @wait_for do
            @comment.destroy do |comment|
              resume if @wait_for.nil?
            end
        
            wait @wait_for do            
              @comments = Comment.all do |comments|
                resume if @wait_for.nil?
              end
          
              wait @wait_for do
                @comments.length.should.equal 2
              end
            end
          end
        end
    
        it "should delete the other saved comment" do
          @comment = Comment.find(@saved_comment_id_confirm) do |comment|
            resume if @wait_for.nil?
          end
      
          wait @wait_for do
            @comment.destroy do |comment|
              resume if @wait_for.nil?
            end
        
            wait @wait_for do            
              @comments = Comment.all do |comments|
                resume if @wait_for.nil?
              end
          
              wait @wait_for do
                @comments.length.should.equal 1
              end
            end
          end
        end
      
        it "should delete the has_many test comment" do
          @comment = Comment.find(@saved_comment_id_has_many) do |comment|
            resume if @wait_for.nil?
          end
      
          wait @wait_for do
            @comment.destroy do |comment|
              resume if @wait_for.nil?
            end
        
            wait @wait_for do            
              @comments = Comment.all do |comments|
                resume if @wait_for.nil?
              end
          
              wait @wait_for do
                @comments.length.should.equal 0
              end
            end
          end
        end
        
      end
      
#       it "should return record from has_many relationship" do
#         @score = Score.find(1)
#         @score.player_id.should.equal 1
#         @score.player.id.should.equal 1
#         @score.player.name.should.equal 'Brian Pattison'
#       end
#   
#       it "should return records from has_many relationship" do
#         @player = Player.find(1)
#         @player.scores.length.should.equal 2
#         @player.scores.first.rank.should.equal 1
#         @player.scores.first.value.should.equal '2000'
#       end
#   
#       it "should take a belongs_to object on initialize" do
#         @player = Player.new(name: 'Kirsten Pattison')
#         @player.save
# 
#         @score = Score.new(rank: 1, value: '50000', player: @player)
#         @score.save
#         @score.player.name.should.equal 'Kirsten Pattison'
#     
#         @player.scores.length.should.equal 1
#         @player.scores.first.value.should.equal '50000'
#       end
    end
    true
  end
  
end