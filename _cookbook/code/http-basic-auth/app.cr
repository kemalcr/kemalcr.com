require "kemal"
require "kemal-basic-auth"

basic_auth "username", "password"

get "/" do |env|
  "This is shown is basic auth ok."
end

Kemal.run
