class CommentsController < ApplicationController
  # GET /comments
  def index
    @comments = Comment.all
    
    render json: @comments
  end

  # GET /comments/1
  def show
    @comment = Comment.find(params[:id])
    
    render json: @comment
  end

  # POST /comments
  def create
    @comment = Comment.new(params[:comment])

    if @comment.save
      render json: @comment, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PUT /comments/1
  def update
    @comment = Comment.find(params[:id])

    if @comment.update_attributes(params[:comment])
      head :no_content
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    head :no_content
  end
end
