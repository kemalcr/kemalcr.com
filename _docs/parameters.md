---
layout: doc
title: HTTP Parameters
order: 11
---

When passing data through an HTTP request, you will often need to use query parameters, or post parameters depending on which HTTP method you're using.

### URL Parameters
Kemal allows you to use variables in your route path as placeholders for passing data. To access URL parameters, you use `env.params.url`.

```ruby
# Matches /hello/kemal
get "/hello/:name" do |env|
  name = env.params.url["name"]
  "Hello back to #{name}"
end

# Matches /users/1
get "/users/:id" do |env|
  id = env.params.url["id"]
  "Found user #{id}"
end
```

### Query Parameters
To access query parameters, you use `env.params.query`.

```ruby
# Matches /resize?width=200&height=200
get "/resize" do |env|
  width = env.params.query["width"]
  height = env.params.query["height"]
end
```

### POST Parameters
Kemal has a few options for accessing post parameters. You can easily access JSON payload from the params, or through the standard post body.

For JSON params, you use `env.params.json`.
For body params, you use `env.params.body`.

```ruby
# The request content type needs to be application/json
# The payload
# {"name": "Serdar", "likes": ["Ruby", "Crystal"]}
post "/json_params" do |env|
  name = env.params.json["name"].as(String)
  likes = env.params.json["likes"].as(Array)
  "#{name} likes #{likes.join(",")}"
end

# Using a standard post body
# name=Serdar&likes=Ruby&likes=Crystal
post "/body_params" do |env|
  name = env.params.body["name"].as(String)
  likes = env.params.body["likes"].as(Array)
  "#{name} likes #{likes.join(",")}"
end
```

**NOTE:** For Array or Hash like params, Kemal will group like keys for you. Alternatively, you can use the square bracket notation `likes[]=ruby&likes[]=crystal`. Be sure to access the param name exactly how it was passed. (i.e. `env.params.body["likes[]"]`).
