require 'clearwater/router'
require 'clearwater/controller'

module Clearwater
  describe Router do
    let(:router) { Router.new }
    let(:articles_controller) {
      Controller.new(default_outlet: articles_index_controller)
    }
    let(:articles_index_controller) { Controller.new }
    let(:article_controller) { Controller.new }
    let(:comments_controller) { Controller.new }
    let(:recent_articles_controller) { Controller.new }

    before do
      # Since the `let` assignments are methods, we can't use them in the
      # router. We have to assign them to variables first.
      article_controller = self.article_controller
      articles_controller = self.articles_controller
      comments_controller = self.comments_controller
      recent_articles_controller = self.recent_articles_controller

      router.add_routes do
        route 'articles' => articles_controller do
          route 'recent' => recent_articles_controller

          route ':id' => article_controller do
            route 'comments' => comments_controller
          end
        end
      end
    end

    it 'knows the current path' do
      router.current_path.should == '/opal_spec'
    end

    it 'can navigate to another path' do
      begin
        router.navigate_to '/zomg'
        router.current_path.should == '/zomg'

      # Clean up browser state if an exception is raised in this spec.
      ensure
        router.back
      end
    end

    describe 'path mapping' do
      it 'maps a plain path' do
        path = '/articles'

        expect(router.routes_for_path(path).map(&:key)).to eq ['articles']
        expect(router.targets_for_path(path)).to eq [articles_controller]
        expect(articles_controller.outlet).to be_nil
      end

      it 'maps a path with a parameter' do
        path = '/articles/1'

        expect(router.canonical_path_for_path(path)).to eq '/articles/:id'
        expect(router.targets_for_path(path)).to eq [articles_controller, article_controller]
        expect(router.params_for_path(path)).to eq id: '1'
      end

      it 'maps a deeply nested path with a parameter' do
        path = '/articles/1/comments'

        expect(router.canonical_path_for_path(path)).to eq '/articles/:id/comments'
        expect(router.targets_for_path(path)).to eq [articles_controller, article_controller, comments_controller]
        expect(router.params_for_path(path)).to eq id: '1'
      end
    end

    it 'sets outlets for each controller' do
      router.set_outlets [
        articles_controller,
        article_controller,
        comments_controller
      ]
      expect(articles_controller.outlet).to be article_controller
      expect(article_controller.outlet).to be comments_controller

      router.set_outlets [articles_controller]
      expect(articles_controller.outlet).to be articles_index_controller
    end
  end
end
