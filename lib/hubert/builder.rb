require 'forwardable'

module Hubert
  class Builder
    extend Forwardable

    def_delegators :components, :protocol=, :protocol
    def_delegators :components, :host=, :host
    def_delegators :components, :path_prefix=, :path_prefix
    def_delegators :components, :port=, :port
    def_delegators :components, :http!, :https!

    def initialize
      @templates = {}
      yield(self) if block_given?
    end

    def path(template, context = {})
      templates(template).render(context)
    end

    def url(template, context = {})
      fail HostNotSet, 'Unable to generate URL without host' if host.nil?

      String.new.tap do|url|
        url <<  protocol + '://'
        url << host
        url << ':' + port unless components.default_port?
        url << path_prefix
        url << path(template, context)
      end
    end

    def templates(name)
      @templates.fetch(name) do
        @templates[name] = Template.new(name)
      end
    end

    private

    def components
      @components ||= Components.new
    end
  end
end
