require 'cgi'

module Hubert
  class Template
    class Renderer

      def initialize(template, ctx)
        @template = template
        @context = Context.new(ctx)
      end

      def render
        result = path
        result << '?' + query if query?
        result
      end

      private

      attr_reader :template, :context

      def path
        template.map do |segment|
          segment.kind_of?(Symbol) ? lookup(segment) : segment
        end * ''
      end

      def query
        context.unused.map do |key, value|
          "#{escape(key)}=#{escape(value)}"
        end * '&'
      end

      def query?
        context.unused.any?
      end

      def lookup(segment)
        escape(context.lookup(segment))
      end

      def escape(stringish)
        CGI.escape(stringish.to_s)
      end
    end
  end
end
