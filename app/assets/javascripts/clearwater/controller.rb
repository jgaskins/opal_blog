module Clearwater
  class Controller
    attr_accessor :view, :outlet, :router, :default_outlet, :parent

    def initialize options={}
      @default_outlet = options.fetch(:default_outlet) { instance_exec(&self.class.default_outlet) }
      @view = options.fetch(:view) { instance_exec(&self.class.view) }

      if view
        view.controller = self
      end
    end

    def call
      view.render
    end

    def call_outlet
      outlet && outlet.render_html
    end

    def render_html
      view && view.render_html
    end

    def params
      router.params_for_path(router.current_path)
    end

    def default_outlet!
      self.outlet = default_outlet
    end

    def outlet= outlet
      @outlet = outlet
      outlet.parent = self if outlet
    end

    def set_csrf_token
      @set_csrf_token ||= proc do |xhr|
        token = Element['meta[name="csrf-token"]']['content']
        `xhr.setRequestHeader('X-CSRF-Token', #{token})`
      end
    end

    def self.view &block
      if block_given?
        @view = block
      else
        @view || proc{}
      end
    end

    def self.default_outlet &block
      if block_given?
        @default_outlet = block
      else
        @default_outlet || proc{}
      end
    end
  end
end
