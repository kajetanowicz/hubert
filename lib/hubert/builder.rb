require 'uri'

module Hubert
  class Builder

    attr_reader :host

    def initialize
      yield(self) if block_given?
    end

    def host=(host)
      @host = URI.parse(host).host
    end
  end
end
