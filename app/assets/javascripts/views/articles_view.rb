require 'clearwater/view'
require 'templates/articles'

class ArticlesView < Clearwater::View
  element '#articles-index'
  template 'articles'
end
