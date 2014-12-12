require 'opal'
require 'jquery'
require 'opal-jquery'
require 'opal-slim'
require 'clearwater/application'

require_tree './views'
require_tree './models'
require_tree './controllers'

def benchmark message
  start = Time.now
  result = yield
  finish = Time.now
  puts "#{message} in #{(finish - start) * 1000}ms"
  result
end

class ApplicationIndexController < Clearwater::Controller
  view { ApplicationIndexView.new }
end

class ApplicationController < Clearwater::Controller
  view { ApplicationView.new }
  default_outlet { ApplicationIndexController.new }

  def current_user
    return @current_user if defined? @current_user
    @current_user = nil

    unless @loading_session
      HTTP.get('/api/v1/session') do |response|
        if response.ok? && response.json[:user]
          @current_user = User.new(response.json[:user])
          @loading_session = false
          call
        end
      end
    end

    @loading_session = true
    @current_user = nil
  end

  def signed_in?
    !!current_user
  end

  def sign_in attributes
    HTTP.post('/api/v1/session',
              beforeSend: set_csrf_token,
              payload: { session: attributes }) do |response|
      if response.ok?
        @current_user = User.new(response.json[:user])
        router.navigate_to '/'
      else
        alert 'Could not sign in.'
      end
    end
  end

  def sign_out
    HTTP.delete('/api/v1/session', beforeSend: set_csrf_token) do |response|
      if response.ok?
        @current_user = nil
        call
      else
        alert 'Could not tell the server to sign out.'
      end
    end
  end
end

class ArticlesIndexController < Clearwater::Controller
  view { ArticlesIndexView.new }
end

class ArticlesController < Clearwater::Controller
  view { ArticlesView.new }
  default_outlet { ArticlesIndexController.new }

  def loading_articles?
    @loading_articles
  end

  def articles
    return @articles if defined? @articles

    fetch_articles
    @articles ||= {}
  end

  def sorted_articles
    return @sorted_articles if @sorted_articles
    
    fetch_articles
    @sorted_articles ||= []
  end

  def fetch_articles
    @loading_articles = true

    HTTP.get('/api/v1/articles') do |response|
      @sorted_articles = response.json.map { |attributes|
        Article.new(attributes)
      }
      @articles = Hash[sorted_articles.map { |a| [a.id, a] }]

      @loading_articles = false
      call
    end
  end

  def add_article article
    articles[article.id] = article
    sorted_articles.unshift article
  end

  def delete_article article
    articles.delete article.id
    sorted_articles.delete article
    call
  end
end

class ArticleController < Clearwater::Controller
  view { ArticleView.new }

  def signed_in?
    parent.parent.signed_in?
  end

  def article
    articles[params[:id].to_i]
  end

  def articles
    parent.articles
  end

  def delete_article
    HTTP.delete(
      "/api/v1/articles/#{article.id}",
      beforeSend: set_csrf_token
    ) do |response|
      if response.ok?
        parent.delete_article article
        router.navigate_to '/articles'
      else
        alert response.error_message
      end
    end
  end
end

class ArticlesNewController < Clearwater::Controller
  attr_accessor :article

  view { ArticlesNewView.new(model: @article = Article.new) }

  def create_article attributes
    HTTP.post(
      '/api/v1/articles',
      payload: { article: attributes },
      beforeSend: set_csrf_token
    ) do |response|
      # parent.fetch_articles
      article = Article.new(response.json)
      parent.add_article article
      router.navigate_to "/articles/#{article.id}"
    end
  end

  def update_attributes attributes
    attributes.each do |attr, value|
      article.public_send "#{attr}=", value
    end
  end
end

class AboutController < Clearwater::Controller
  view { AboutView.new }
end

router = Clearwater::Router.new do
  route 'articles' => ArticlesController.new do
    route 'new' => ArticlesNewController.new
    route ':id' => ArticleController.new
  end

  route 'session' => SessionController.new

  route 'about' => AboutController.new
end

OpalBlog = Clearwater::Application.new(router: router)

Document.ready? do
  OpalBlog.call
end
