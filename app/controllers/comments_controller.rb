class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: "Comment added."
    else
      redirect_to @post, alert: @comment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment
    @comment.destroy
    redirect_to @comment.post, notice: "Comment deleted."
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
