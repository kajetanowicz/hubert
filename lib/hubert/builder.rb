require 'uri'

module Hubert

  InvalidProtocol = Class.new(StandardError)

  class Builder

    attr_reader :protocol, :host

    def initialize
      yield(self) if block_given?
    end

    def protocol=(protocol)
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
      @host = URI.parse(host).host
    end
  end
end
