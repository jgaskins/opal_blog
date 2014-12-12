module API
  module V1
    module Store
      class CategoriesController < ApplicationController
        def index
          render json: CategoriesSerializer.new(Category.all).as_json
        end

        class CategoriesSerializer
          attr_reader :categories

          def initialize categories
            @categories = categories.map do |category|
              CategorySerializer.new(category)
            end
          end

          def as_json
            categories.map(&:as_json)
          end
        end

        class CategorySerializer
          attr_reader :category

          def initialize category
            @category = category
          end

          def as_json
            {
              id: category.id,
              name: category.name,
            }
          end
        end
      end
    end
  end
end
