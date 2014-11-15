require 'uri'

module Hubert

  InvalidProtocol = Class.new(StandardError)

  class Builder

    attr_reader :protocol, :host, :path_prefix

    def initialize
      yield(self) if block_given?
    end

    def protocol=(protocol)
      protocol.strip!
      if protocol =~ /(http)|(HTTP)/i
        @protocol = protocol.downcase
      else
        fail InvalidProtocol, "Provided protocol: [#{protocol}] is invalid"
      end
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

      @path_prefix = path
    end
  end
end
