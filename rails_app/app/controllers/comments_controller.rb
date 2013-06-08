class CommentsController < ApplicationController
  # GET /comments
  def index
    if params[:ids]
      @comments = Comment.where(id: params[:ids])
    elsif params[:query]
      @comments = Comment.where(params[:query])
    else
      @comments = Comment.all
    end
    
    render json: @comments
  end

  # GET /comments/1
  def show
    @comment = Comment.find(params[:id])
    
    render json: @comment
  end

  # POST /comments
  def create
    # Fake saving the comment by assigning an ID
    @comment = Comment.new(params[:comment])
    @comment.id = 10
    
    if @comment.valid?
      render json: @comment, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PUT /comments/1
  def update
    # Fake updating the comment by creating
    # a new comment with the updated params
    @comment = Comment.new(params[:comment])
    @comment.id = params[:id]
    
    if @comment.valid?
      head :no_content
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment = Comment.find(params[:id])
    # Don't actually delete it
    # @comment.destroy 

    head :no_content
  end
end
