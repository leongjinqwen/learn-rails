class ArticlesController < ApplicationController
  before_action :logged_in_user

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    # @article = Article.new(title: params[:article][:title], body: params[:article][:body])
    @article = Article.new(article_params)
    @article.user = @current_user

    if @article.save
      redirect_to @article #redirect to show
    else
      render :new # render template new
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path
  end
  
  private
  def article_params
    params.require(:article).permit(:title, :body, images: [])
  end
end
