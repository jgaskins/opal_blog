require 'clearwater/form_view'
require 'templates/session'

class SessionView < Clearwater::FormView
  element '#session'
  template 'session'

  def initialize *args
    super

    event :submit, '#sign-in-form' do |event|
      event.prevent_default
      sign_in session_attributes
    end
  end

  def session_attributes
    {
      email: form_input(:email),
      password: form_input(:password),
    }
  end
end

class SessionController < Clearwater::Controller
  view { SessionView.new }

  def sign_in attributes={}
    # Pass the sign-in to the app controller
    parent.sign_in attributes
  end
end
