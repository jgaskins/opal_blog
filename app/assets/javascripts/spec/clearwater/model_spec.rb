require 'clearwater/model'

module Clearwater
  describe Model do
    let(:model) do
      Class.new(Model) {
        attributes :foo, :bar
      }.new(foo: 'foo', bar: 'bar')
    end

    it 'sets up attributes' do
      expect(model.foo).to eq 'foo'
      expect(model.bar).to eq 'bar'
    end

    it 'sets up bindings' do
      changed = false

      # In practice, it needs to re-render the block, but we can at least
      # check to see that the block is executed.
      model.add_binding :foo do
        changed = true
      end

      expect(changed).to be_falsey
      model.foo = 'FOO'
      expect(changed).to be_truthy
    end
  end
end
