require 'forwardable'

module Hubert
  class Template
    PH = /:[a-zA-Z_]+/

    extend Forwardable
    def_delegator :@compiled, :map

    def initialize(template)
      @template = template
      @compiled = []

      compile!
    end

    def render(ctx = {})
      Renderer.new(self, ctx).render
    end

    def placeholders
      @compiled.select { |segment| segment.is_a?(Symbol) }
    end

    private

    def compile!
      normalize_template!
      extract_placeholders!
    end

    def normalize_template!
      path = @template

      path = path[0..-2] if path.end_with?('/')
      path = path[1..-1] if path.start_with?('/')

      @template = '/' + path
    end

    def extract_placeholders!
      tail = @template

      loop do
        head, placeholder, tail = tail.partition(PH)
        @compiled << head
        break if placeholder.empty?
        @compiled << placeholder[1..-1].to_sym
      end
    end
  end
end
