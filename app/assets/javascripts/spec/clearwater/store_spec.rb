require 'clearwater/store'

module Clearwater
  describe Store do
    let(:protocol) { double('HTTP API') }
    let(:store) do
      Store.new(protocol: protocol)
    end
    let(:response) { double('HTTP Response') }
    let(:article) { Article.new }
    let(:article_class) do
      Class.new do
        attr_reader :id
      end
    end

    before do
      stub_const 'Article', article_class
      allow(Article).to receive(:name) { 'Article' }
    end

    it 'finds all models' do
      expect(protocol).to receive(:get).with('/api/articles/') {
        double('HTTP Response', body: '[{"id":1}]')
      }
      articles = store.all(Article)
      expect(articles.first).to be_a Article
      expect(articles.first.id).to eq 1
    end

    it 'finds a model with a specific id' do
      expect(response).to receive(:body) { '{"id":1}' }
      expect(protocol).to receive(:get).with('/api/articles/1') { response }
      retrieved = store.find(Article, 1)
      expect(retrieved).to be_a Article
      expect(retrieved.id).to eq 1
    end

    it 'only triggers a fetch once' do
      allow(response).to receive(:body) { '{"id":1}' }
      expect(protocol).to receive(:get)
        .with('/api/articles/1')
        .once
        .and_return response
      store.find(Article, 1)
      store.find(Article, 1)
    end

    it 'saves a new model and stores the id inside it' do
      allow(response).to receive(:body) { '{"id":1}' }
      allow(response).to receive(:ok) { true }
      expect(protocol).to receive(:post).with('/api/articles/') { response }
      store.save article
      expect(article.id).to eq 1
    end

    it 'updates an existing model' do
      allow(article).to receive(:id) { 1 }
      allow(response).to receive(:ok) { true }
      expect(protocol).to receive(:patch).with('/api/articles/1') { response }
      store.save article
    end

    it 'deletes an existing model' do
      allow(article).to receive(:id) { 1 }
      expect(protocol).to receive(:delete).with '/api/articles/1'
      store.delete article
    end
  end
end
