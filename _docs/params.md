---
layout: doc
title: "Params"
order: 7
---

Kemal supports multiple types of parameters.

#### Query string

```crystal
# GET /search?q=kemal

get "/search" do |env|
  env.params.query["q"]?
end
```

#### Route parameters

```crystal
# GET /items/42

get "/items/:id" do |env|
  env.params.url["id"].to_i32
end
```

#### URL Encoded form

When content type is `application/x-www-form-urlencoded`.

```crystal
post "/foo" do |env|
  env.params.body["name"]
end
```

#### Multipart form

When content type is `multipart/form-data`. Stored in `env.params.body` and `env.params.query`.

#### Application JSON

When content type is `application/json`.

```crystal
# Request sent with header `Content-Type: application/json`

post "/foo" do |env|
  env.params.json
end
```
