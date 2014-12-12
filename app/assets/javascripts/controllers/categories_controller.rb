require 'clearwater/controller'
require 'views/categories_view'

class CategoriesController < Clearwater::Controller
  view { CategoriesView.new }

  def categories
    parent.categories
  end
end
