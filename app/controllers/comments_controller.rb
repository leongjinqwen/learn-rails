class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @article = Article.find(params[:article_id])
    
    # @comment = @article.comments.create(comment_params) 
    # `create` is an association method that automatically link the comment to that particular article
    
    @comment = Comment.new(comment_params)
    @comment.article = @article
    @comment.user = @current_user

    if @comment.save
      redirect_to article_path(@article)
    else
      flash[:danger] = []
      @comment.errors.full_messages_for(:body).each do |message|
        flash[:danger] << message
      end
      @comment.errors.full_messages_for(:commenter).each do |message|
        flash[:danger] << message
      end
      redirect_to article_path(@article)
    end
  end

  def destroy
    @article = Article.find(params[:article_id]) # find the article where this comment belongs to
    @comment = @article.comments.find(params[:id]) # find comment with id
    @comment.destroy # delete the comment
    redirect_to article_path(@article)
  end
  
  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
