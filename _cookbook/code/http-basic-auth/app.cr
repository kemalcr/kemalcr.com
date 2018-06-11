require "kemal"
require "kemal-basic-auth"

basic_auth "username", "password"

get "/" do |env|
  "This is shown if basic auth successful."
end

Kemal.run
