require "kemal"

Kemal.run do |config|
  config.server.not_nil!.bind_unix "path/to/socket.sock"
end