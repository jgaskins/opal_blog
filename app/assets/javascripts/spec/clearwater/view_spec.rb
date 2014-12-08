require 'clearwater/view'

module Clearwater
  describe View do
    let(:view) do
      Class.new(View) do
        def initialize
          @element = Element.new('div')
          @element.id = 'foo'
          @template = Template.new('foo')

          event(:click) { element.html = 'clicked' }
        end

        def self.name
          'MyView'
        end
      end.new
    end

    it 'knows which element it references' do
      expect(view.element.id).to eq 'foo'
    end

    it 'knows which template it uses' do
      expect(view.template).to be_a Template
    end

    it 'executes a block on an event' do
      puts 'starting'
      view.element.trigger :click

      expect(view.element.html).to eq 'clicked'
      puts 'finished'
    end
  end
end
