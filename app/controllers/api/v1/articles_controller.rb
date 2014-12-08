module API
  module V1
    class ArticlesController < ApplicationController
      def index
        render json: Article.all.order(created_at: :desc)
      end

      # GET /articles/1
      def show
        respond_with Article.find(params[:id])
      end

      def create
        @article = Article.new(article_params)

        @article.save!
        render json: @article, status: :created
      end

      # PATCH/PUT /articles/1
      def update
        Article.find(params[:id]).update!(article_params)
        render json: {}, status: :ok
      end

      def destroy
        Article.find(params[:id]).destroy!
        render json: {}, status: :ok
      end

      private
      def article_params
        params.require(:article).permit(:title, :body)
      end
    end
  end
end
