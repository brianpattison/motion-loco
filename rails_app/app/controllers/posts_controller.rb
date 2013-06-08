class PostsController < ApplicationController
  # GET /posts
  def index
    if params[:ids]
      @posts = Post.where(id: params[:ids])
    elsif params[:query]
      @posts = Post.where(params[:query])
    else
      @posts = Post.all
    end
    
    render json: @posts
  end

  # GET /posts/1
  def show
    @post = Post.find(params[:id])
    
    render json: @post
  end

  # POST /posts
  def create
    # Fake saving the post by assigning an ID
    @post = Post.new(params[:post])
    @post.id = 10
    
    if @post.valid?
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PUT /posts/1
  def update
    # Fake updating the post by creating
    # a new post with the updated params
    @post = Post.new(params[:post])
    @post.id = params[:id]
    
    if @post.valid?
      head :no_content
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post = Post.find(params[:id])
    # Don't actually delete it
    # @post.destroy 

    head :no_content
  end
end
