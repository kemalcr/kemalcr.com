require "kemal"
require "json"

# Define a route for the root path "/"
get "/" do |env|
  # Set response content type to JSON
  # This tells clients to expect JSON data
  env.response.content_type = "application/json"

  # Create a simple hash and convert it to JSON
  # Returns a JSON string: {"name": "Serdar", "age": 27}
  {name: "Serdar", age: 27}.to_json
end

# Start the Kemal web server
Kemal.run
