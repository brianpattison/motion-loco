class BlogUsersController < ApplicationController
  # GET /blog_users
  def index
    if params[:ids]
      @blog_users = BlogUser.where(id: params[:ids])
    elsif params[:query]
      @blog_users = BlogUser.where(params[:query])
    else
      @blog_users = BlogUser.all
    end
    
    render json: @blog_users
  end

  # GET /blog_users/1
  def show
    @blog_user = BlogUser.find(params[:id])
    
    render json: @blog_user
  end

  # POST /blog_users
  def create
    @blog_user = BlogUser.new(params[:blog_user])
    
    if @blog_user.save
      render json: @blog_user, status: :created
    else
      render json: @blog_user.errors, status: :unprocessable_entity
    end
  end

  # PUT /blog_users/1
  def update
    @blog_user = BlogUser.find(params[:id])
    
    if @blog_user.update_attributes(params[:blog_user])
      head :no_content
    else
      render json: @blog_user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /blog_users/1
  def destroy
    @blog_user = BlogUser.find(params[:id])
    @blog_user.destroy 

    head :no_content
  end
end
