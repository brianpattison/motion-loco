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
    @post = Post.new(params[:post])

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PUT /posts/1
  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(params[:post])
      head :no_content
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    head :no_content
  end
end
