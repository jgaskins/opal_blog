require 'clearwater/application'

module Clearwater
  describe Application do
    let(:router) { double('Router', :application= => nil) }
    let(:store) { double('Store') }
    let(:controller) { double('Controller', :router= => nil) }

    let(:app) {
      Application.new(
        store: store,
        router: router,
        controller: controller
      )
    }

    it 'sets the router' do
      expect(app.router).to be router
    end

    it 'sets the data store' do
      expect(app.store).to be store
    end

    it 'sets the application controller' do
      expect(app.controller).to be controller
    end
  end
end
