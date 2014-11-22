require 'uri'

module Hubert
  class Builder
    DEFAULT_PORTS = { 'http' => '80', 'https' => '443' }

    attr_reader :host

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
        url << ':' + port unless DEFAULT_PORTS.fetch(protocol) == port
        url << path_prefix
        url << path(template, context)
      end
    end

    def templates(name)
      @templates.fetch(name) do
        @templates[name] = Template.new(name)
      end
    end

    def protocol=(protocol)
      protocol = protocol.to_s unless protocol.is_a?(String)
      protocol.strip!
      if protocol =~ /(http)|(https)/i
        @protocol = protocol.downcase
      else
        fail InvalidProtocol, "Provided protocol: [#{protocol}] is invalid"
      end
    end

    def protocol
      @protocol ||= 'http'
    end

    def http!
      @protocol = 'http'
    end

    def https!
      @protocol = 'https'
    end

    def host=(host)
      host.strip!
      host = 'http://' + host if URI.parse(host).scheme.nil?
      @host = URI.parse(host).host
    end

    def path_prefix=(path)
      path.strip!
      path = URI.parse(path).path
      path = path[0..-2] if path.end_with?('/')
      path = path[1..-1] if path.start_with?('/')

      @path_prefix = '/' + path
    end

    def path_prefix
      @path_prefix ||= ''
    end

    def port
      @port ||= DEFAULT_PORTS.fetch(protocol, '80')
    end

    def port=(port)
      @port = port.to_s
    end
  end
end
