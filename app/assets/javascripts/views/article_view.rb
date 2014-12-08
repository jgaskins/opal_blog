require 'clearwater/view'
require 'templates/article'

class ArticleView < Clearwater::View
  element '#article'
  template 'article'

  def initialize
    super

    event :click, '#toggle-comments' do
      @comments_visible = !@comments_visible
      render
    end

    event :click, '#delete-article' do |event|
      delete_article
    end
  end

  def comments_visible?
    @comments_visible
  end
end
