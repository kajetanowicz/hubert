module Hubert
  module DSL
    class << self
      def builders
        @builder ||= {}
      end

      def builder_for(klass)
        builders.fetch(klass) do
          builders[klass] = Builder.new
        end
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

    def url(path, options = {})
      unless options.key?(:as)
        fail PathAliasNotSet, 'Please specify ":as" options when calling url method'
      end

      method_name = "#{options[:as]}_url"

      define_method(method_name) do |ctx = {}|
        DSL.builder_for(self.class).url(path, ctx)
      end
    end

    def http!
      DSL.builder_for(self).http!
    end

    def https!
      DSL.builder_for(self).https!
    end

    def host(host)
      DSL.builder_for(self).host = host
    end

    def port(port)
      DSL.builder_for(self).port = port
    end

    def path_prefix(path_prefix)
      DSL.builder_for(self).path_prefix = path_prefix
    end
  end
end
