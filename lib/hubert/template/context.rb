module Hubert
  class Template

    KeyNotFound = Class.new(StandardError)

    class Context
      def initialize(ctx = {})
        @context = ctx
        @lookups = []
      end

      def lookup(key)
        @lookups << key

        @context.fetch(key) do
          fail KeyNotFound, "Unable to find a value for a given key [#{key}]"
        end
      end

      def unused
        lookups.reduce(@context.dup) do |ctx, key|
          ctx.delete(key); ctx
        end
      end

      def lookups
        @lookups.uniq
      end
    end
  end
end
