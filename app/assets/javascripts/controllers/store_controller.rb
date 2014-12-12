require 'clearwater/controller'
require 'controllers/categories_controller'
require 'views/store_view'

class StoreController < Clearwater::Controller
  view { StoreView.new }
  default_outlet { CategoriesController.new }

  def categories
    return @categories if defined? @categories

    HTTP.get '/api/v1/categories' do |response|
      if response.ok?
        @categories = response.json[:categories].map { |category_params|
          ProductCategory.new(category_params)
        }
      else
        alert "Couldn't fetch categories from the server: #{response.error_message}"
      end
    end

    @categories ||= []
  end
end
