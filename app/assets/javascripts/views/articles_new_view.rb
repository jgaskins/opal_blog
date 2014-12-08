require 'clearwater/form_view'
require 'templates/articles/new'

class ArticlesNewView < Clearwater::FormView
  element '#new-article-form'
  template 'articles/new'

  def initialize
    super

    event :click, '#post-article' do |e|
      create_article article_attributes
      controller.article = @model = Article.new
    end

    event :keyup, '.attribute' do |e|
      e.stop_propagation
      update_attributes article_attributes
    end
  end

  def article_attributes
    {
      title: form_input(:title),
      body: form_input(:body),
    }
  end
end
