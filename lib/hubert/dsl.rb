module Hubert
  module DSL
    class << self
      def extended(klass)
        builders[klass] = Builder.new
      end

      def builders
        @builder ||= {}
      end

      def builder_for(klass)
        builders.fetch(klass)
      end
    end


    def path(path, options = {})
      unless options.key?(:as)
        fail PathAliasNotSet, 'Please specify ":as" options when calling path method'
      end

      method_name = "#{options[:as]}_path"

      define_method(method_name) do |ctx = {}|
        DSL.builder_for(self.class).path(path, ctx)
      end
    end
  end
end
