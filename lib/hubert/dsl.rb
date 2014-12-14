module Hubert
  module DSL

    class MethodDefiner
      def initialize(klass)
        @klass = klass
      end

      def define(method, path, options)
        ensure_alias!(options, method)

        @klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{options[:as]}_#{method}(ctx = {})                  # def get_items_path(ctx = {})
            self.class._hubert_builder.#{method}('#{path}', ctx)   #    self.class._hubert_builder.url('some/:interesting/path:id', ctx)
          end                                                      # end
        RUBY
      end

      private

      def ensure_alias!(options, method)
        if options.fetch(:as, '') =~ /^\s*$/
          fail AliasNotSet, "Please specify ':as' option when defining new #{method}"
        end
      end
    end

    def path(path, options = {})
      MethodDefiner.new(self).define(:path, path, options)
    end

    def url(path, options = {})
      MethodDefiner.new(self).define(:url, path, options)
    end

    def http!
      _hubert_builder.http!
    end

    def https!
      _hubert_builder.https!
    end

    def host(host)
      _hubert_builder.host = host
    end

    def port(port)
      _hubert_builder.port = port
    end

    def path_prefix(path_prefix)
      _hubert_builder.path_prefix = path_prefix
    end

    def _hubert_builder
      @_hubert_builder ||= Builder.new
    end
  end
end
