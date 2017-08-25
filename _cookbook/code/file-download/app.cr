require "kemal"

get "/" do |env|
  send_file env, "/path/to/your_file"
end

Kemal.run
