require 'clearwater/view'
require 'templates/application'

class ApplicationView < Clearwater::View
  element  '#app'
  template 'application'

  def initialize *args
    super

    event :click, '#sign-out' do
      sign_out
    end
  end
end
