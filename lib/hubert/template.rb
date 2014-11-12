module Hubert
  class Template
    PH = /:[a-zA-Z_]+/

    def initialize(template)
      @template = template
      @compiled = []
      @placeholders = []

      compile!
    end

    def render(ctx = {})
      @compiled.map { |segment|
        segment.kind_of?(Symbol) ? (ctx[segment] || '') : segment
      }.join('')
    end

    private

    def compile!
      normalize_template!
      extract_placeholders!
    end

    def normalize_template!
      suffix = @template
        .split('/')
        .delete_if(&:empty?)
        .join('/')

      @template = '/' + suffix
    end

    def extract_placeholders!
      tail = @template

      loop do
        head, ph, tail = tail.partition(PH)
        @compiled << head
        break if ph.empty?

        placeholder = ph[1..-1].to_sym
        @compiled << placeholder
        @placeholders << placeholder
      end
    end
  end
end
