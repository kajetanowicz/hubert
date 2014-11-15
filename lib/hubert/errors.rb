module Hubert
  HubertError = Class.new(StandardError)

  KeyNotFound = Class.new(HubertError)

  InvalidProtocol = Class.new(HubertError)
end
