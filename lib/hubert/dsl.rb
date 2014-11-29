module Hubert
  module DSL
    def path(path, options = {})
      unless options.key?(:as)
        fail PathAliasNotSet, 'Please specify ":as" options when calling path method'
      end

      method_name = "#{options[:as]}_path"

      define_method(method_name) do |*args|
        tpl = Template.new(path)

        options = args.last.is_a?(Hash) ? args.pop : {}

        unless tpl.placeholders.size == args.size
          fail ArgumentError, "wrong number of arguments (#{args.size} for #{tpl.placeholders.size}..#{tpl.placeholders.size + 1})"
        end

        tpl.render(Hash[tpl.placeholders.zip(args)].merge(options))
      end
    end
  end
end
