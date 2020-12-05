require "kemal"
require "json"

# You can use JSON.mapping to directly create an object from JSON
class User
  include JSON::Serializable

  property username : String, password : String
end

post "/" do |env|
  user = User.from_json env.request.body.not_nil!
  {username: user.username, password: user.password}.to_json
end

Kemal.run
