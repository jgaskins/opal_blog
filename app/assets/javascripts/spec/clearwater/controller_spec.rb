require 'clearwater/controller'
require 'clearwater/view'

module Clearwater
  describe Controller do
    let(:view) { View.new }
    let!(:controller) do
      my_view = view
      Class.new(Controller) do
        view { my_view }

        def self.name
          'MyController'
        end
      end.new
    end

    it 'renders the view' do
      expect(view).to receive(:render)

      controller.call
    end

    it 'sets the controller for the view to itself' do
      expect(view.controller).to eq controller
    end

    it 'can have be assigned an outlet' do
      outlet = double('Outlet', :parent= => nil)
      controller.outlet = outlet
      expect(controller.outlet).to be outlet
    end
  end
end
