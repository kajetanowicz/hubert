module Hubert
  HubertError = Class.new(StandardError)

  KeyNotFound = Class.new(HubertError)

  InvalidProtocol = Class.new(HubertError)

  HostNotSet = Class.new(HubertError)
end
