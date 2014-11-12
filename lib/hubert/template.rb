module Hubert
  class Template
    PH = /:[a-zA-Z_]+/

    def initialize(template)
      @template = template
      @compiled = []

      compile!
    end

    def render(ctx = {})
      context = Context.new(ctx)

      path = @compiled.map do |segment|
        segment.kind_of?(Symbol) ? context.lookup(segment) : segment
      end
      .join('')

      query = context.unused.map {|key, value| "#{key}=#{value}"} * '&'

      path.tap do |p|
        p << '?' + query unless query.empty?
      end
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
        head, placeholder, tail = tail.partition(PH)
        @compiled << head
        break if placeholder.empty?
        @compiled << placeholder[1..-1].to_sym
      end
    end
  end
end
