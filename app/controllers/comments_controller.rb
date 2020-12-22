class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    
    # @comment = @article.comments.create(comment_params) 
    # `create` is an association method that automatically link the comment to that particular article
    
    @comment = Comment.new(article: @article, commenter: comment_params[:commenter], body: comment_params[:body])
    
    if @comment.save
      redirect_to article_path(@article)
    else
      flash[:notice] = []
      @comment.errors.full_messages_for(:body).each do |message|
        flash[:notice] << message
      end
      @comment.errors.full_messages_for(:commenter).each do |message|
        flash[:notice] << message
      end
      render "articles/show"
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
    params.require(:comment).permit(:commenter, :body)
  end
end
