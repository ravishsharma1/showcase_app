class PostsController < ApplicationController
  def index
    @q = Post.published.ransack(params[:q])
    @posts = @q.result.includes(:category, :user).recent
    @posts = @posts.where(category_id: params[:category_id]) if params[:category_id].present?
    @posts = @posts.limit(20)
    @categories = Category.all
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user).recent
    @comment = Comment.new
  end
end
