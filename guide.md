---
layout: default
title: Kemal - Guide
---

## Table of Contents

1. [Getting Started](#getting-started)
   - [Installing Kemal](#installing-kemal)
   - [Using Kemal](#using-kemal)
   - [Running Kemal](#running-kemal)
2. [Routes](#routes)
3. [HTTP Parameters](#http-parameters)
   - [URL Parameters](#url-parameters)
   - [Query Parameters](#query-parameters)
   - [POST / Form Parameters](#post-form-parameters)
4. [HTTP Request / Response Context](#context)
   - [Context Storage](#context-storage)
   - [Request Properties](#request-properties)
5. [Views / Templates](#views-templates)
   - [Using Layouts](#using-layouts)
   - [content_for and yield_content](#content_for-and-yield_content)
   - [Using Common Paths](#using-common-paths)
6. [Filters](#filters)
7. [Helpers](#helpers)
   - [Browser Redirect](#browser-redirect)
   - [Halt](#halt)
   - [Custom Errors](#custom-errors)
   - [Send File](#send-file)
8. [Middleware](#middleware)
   - [Creating your own middleware](#creating-your-own-middleware)
   - [Conditional Middleware Execution](#conditional-middleware-execution)
   - [Creating a custom Logger middleware](#creating-a-custom-logger-middleware)
   - [Kemal Middleware](#kemal-middleware)
9. [File Upload](#file-upload)
   - [Basic File Upload](#basic-file-upload)
   - [Advanced File Upload with Validation](#advanced-file-upload-with-validation)
   - [Multiple File Upload](#multiple-file-upload)
10. [Sessions](#sessions)
11. [WebSockets](#websockets)
12. [Testing](#testing)
13. [Static Files](#static-files)
14. [Configuration](#configuration)
    - [Server Configuration](#server-configuration)
    - [Static Files Configuration](#static-files-configuration)
    - [Logging Configuration](#logging-configuration)
    - [SSL Configuration](#ssl-configuration)
    - [Environment Configuration](#environment-configuration)
    - [Error Handling](#error-handling)
    - [Handler Configuration](#handler-configuration)
15. [CLI](#cli)
16. [SSL](#ssl)
17. [Security](#security)
    - [Resource Limits](#resource-limits)
    - [Defense](#defense)
18. [Deployment](#deployment)
    - [Production Build](#production-build)
    - [Docker Deployment](#docker-deployment)
    - [Cloud Platforms](#cloud-platforms)
    - [VPS and Bare Metal](#vps-bare-metal)
    - [Production Best Practices](#production-best-practices)
    - [Deployment Strategies](#deployment-strategies)
    - [Database Migrations](#database-migrations)
    - [Continuous Deployment](#continuous-deployment)
    - [Performance Tuning](#performance-tuning)
    - [Capistrano](#capistrano)
    - [Cross-compilation](#cross-compilation)

# [Getting Started](#getting-started)

This guide assumes that you already have Crystal installed. If not, check out the [Crystal installation methods](https://crystal-lang.org/install/) and come back when you're done.

### [Installing Kemal](#installing-kemal)

First you need to create your application:

```
crystal init app your_app
cd your_app
```

Then add *kemal* to the `shard.yml` file as a dependency.

```
dependencies:
  kemal:
    github: kemalcr/kemal
```

Finally run `shards` to get the dependencies:

```
shards install
```

You should see something like this:

```
$ shards install
Updating https://github.com/kemalcr/kemal.git
Installing kemal (1.9.0)
```

That's it! You're now ready to use Kemal in your application.

### [Using Kemal](#using-kemal)

You can do awesome stuff with Kemal. Let's start with a simple example. Just change the content of `src/your_app.cr` to:

```ruby
require "kemal"

get "/" do
  "Hello World!"
end

Kemal.run
```

### [Running Kemal](#running-kemal)

Starting your application is easy. Simply run:

```
crystal run src/your_app.cr
```

If everything goes well, you should see a message saying that Kemal is running.
If you are using Windows, use `http://localhost:3000` or `http://127.0.0.1:3000` instead of `http://0.0.0.0:3000`.

```
[development] Kemal is ready to lead at http://0.0.0.0:3000
2015-12-01 13:47:48 UTC 200 GET / 666µs
```

Congratulations on your first Kemal application! This is just the beginning. Keep reading to learn how to do more with Kemal.

# [Routes](#routes)

You can handle HTTP methods as easy as writing method names and the route with a code block. Kemal will handle all the hard work.

```ruby
# GET - Retrieve data, list resources, show pages
# Use for: Reading data, displaying pages, listing items
get "/" do
  # Example: Show homepage, list users, display a blog post
  "Hello World!"
end

# POST - Create new resources
# Use for: Creating new records, form submissions, user registration
post "/" do
  # Example: Create new user, submit contact form, add item to cart
end

# PUT - Replace entire resource
# Use for: Complete resource updates, replacing all fields
put "/" do
  # Example: Update entire user profile, replace configuration
end

# PATCH - Partially update resource
# Use for: Updating specific fields without replacing the entire resource
patch "/" do
  # Example: Update only user's email, change post status
end

# DELETE - Remove resources
# Use for: Deleting records, removing items, user logout
delete "/" do
  # Example: Delete user account, remove blog post, clear cache
end
```

Any **string** returned from a route will output to the browser.
Routes are matched in the order they are defined. The first route that matches the request is invoked.

# [HTTP Parameters](#http-parameters)

When passing data through an HTTP request, you will often need to use query parameters, or post parameters depending on which HTTP method you're using.

### [URL Parameters](#url-parameters)
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

# Matches /dir/and/anything/after
get "/dir/*all" do |env|
  all = env.params.url["all"]
  "Found path #{all}"
end
```

### [Query Parameters](#query-parameters)
To access query parameters, you use `env.params.query`.

```ruby
# Matches /resize?width=200&height=200
get "/resize" do |env|
  width = env.params.query["width"]
  height = env.params.query["height"]
end
```

### [POST / Form Parameters](#post-form-parameters)
Kemal has a few options for accessing post parameters. You can easily access JSON payload from the parameters, or through the standard post body.

For JSON parameters, use `env.params.json`.
For body parameters, use `env.params.body`.

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

**NOTE:** For Array or Hash like parameters, Kemal will group like keys for you. Alternatively, you can use the square bracket notation `likes[]=ruby&likes[]=crystal`. Be sure to access the param name exactly how it was passed. (i.e. `env.params.body["likes[]"]`).

# [HTTP Request / Response Context](#context)

Accessing the HTTP request/response context (query paremeters, body, content_type, headers, status_code) is super easy. You can use the context returned from the block:

```ruby
# Matches /hello/kemal
get "/hello/:name" do |env|
  name = env.params.url["name"]
  "Hello back to #{name}"
end

# Matches /resize?width=200&height=200
get "/resize" do |env|
  width = env.params.query["width"]
  height = env.params.query["height"]
end

# Easily access JSON payload from the parameters.
# The request content type needs to be application/json
# The payload
# {"name": "Serdar", "likes": ["Ruby", "Crystal"]}
post "/json_params" do |env|
  name = env.params.json["name"].as(String)
  likes = env.params.json["likes"].as(Array)
  "#{name} likes #{likes.each.join(',')}"
end

# Set the content as application/json and return JSON
get "/user.json" do |env|
  user = {name: "Kemal", language: "Crystal"}.to_json
  env.response.content_type = "application/json"
  user
end

# Add headers to your response
get "/headers" do |env|
  env.response.headers["Accept-Language"] = "tr"
  env.response.headers["Authorization"] = "Token 12345"
end

# Set response status code
get "/status-code" do |env|
  env.response.status_code = 404
end
```

### [Context Storage](#context-storage)

Contexts are useful for sharing states between filters and middleware. You can use `context` to store some variables and access them later at some point. Each stored value only exist in the lifetime of request / response cycle.

```ruby
before_get "/" do |env|
  env.set "is_kemal_cool", true
end

get "/" do |env|
  is_kemal_cool = env.get "is_kemal_cool"
  "Kemal cool = #{is_kemal_cool}"
end
```

This renders `Kemal cool = true` when a request is made to `/`.

If you prefer a safer version use `env.get?` which won't raise when the key doesn't exist and will return `nil` instead.

```ruby
get "/" do |env|
  non_existent_key = env.get?("non_existent_key") # => nil
end
```

Context storage also supports custom types. You can register and use a custom type as the following:

```ruby
class User
 property name
end

add_context_storage_type(User)

before "/" do |env|
  env.set "user", User.new(name: "dummy-user")
end

get "/" do
  user = env.get "user"
end
```

Be aware that you have to declare the custom type before trying to add with `add_context_storage_type`.

### [Request Properties](#request-properties)

Some common request information is available at `env.request.*`:

- **method** - the HTTP method
  - e.g. `GET`, `POST`, ...
- **headers** - a hash containing relevant request header information
- **body** - the request body
- **version** - the HTTP version
  - e.g. `HTTP/1.1`
- **path** - the uri path
  - e.g. `http://kemalcr.com/docs/context?lang=cr` => `/docs/context`
- **resource** - the uri path and query parameters
  - e.g. `http://kemalcr.com/docs/context?lang=cr` => `/docs/context?lang=cr`
- **cookies**
  - e.g. `env.request.cookies["cookie_name"].value`

# [Views / Templates](#views-templates)

You can use ERB-like built-in [ECR](http://crystal-lang.org/api/ECR.html) to render dynamic views.

```ruby
get "/:name" do |env|
  name = env.params.url["name"]
  render "src/views/hello.ecr"
end
```

Your `hello.ecr` view should have the same context as the method.

```erb
Hello <%= name %>
```

## [Using Layouts](#using-layouts)

You can use **layouts** in Kemal. You can do this by passing a second argument to the `render` method.

```ruby
get "/:name" do
  render "src/views/subview.ecr", "src/views/layouts/layout.ecr"
end
```

In your layout file, you need to return the output of `subview.ecr` with the `content` variable (like `yield` in Rails).

```erb
<html>
<head>
  <title>My Kemal Application</title>
</head>
<body>
  <%= content %>
</body>
</html>
```

### [content_for and yield_content](#content_for-and-yield_content)

You can capture blocks inside views to be rendered later during the request
with the `content_for` helper. The most common use is to populate different
parts of your layout from your view.

#### [Usage](#usage)

First, call `content_for`, generally from a view, to capture a block of markup
with an identifier:

```erb
# index.ecr
<% content_for "some_key" do %>
  <chunk of="html">...</chunk>
<% end %>
```

Then, call **yield_content** with that identifier, generally from a
layout, to render the captured block:

```erb
# layout.ecr
<%= yield_content "some_key" %>
```

This is useful because some of your views may need specific JavaScript tags or
stylesheets and you don't want to use these tags in all of your pages.
To solve this problem, you can use `<%= yield_content "scripts_and_styles" %>` in
your `layout.ecr`, inside the `<head>` tag, and each view can call `content_for`
with the appropriate set of tags that should be added to the layout.

## [Using Common Paths](#using-common-paths)

Since Crystal does not allow using variables in macro literals, you need to generate
another *helper macro* to make the code easier to read and write.

```ruby
{% raw %}
macro my_renderer(filename)
  render "my/app/view/base/path/#{ {{filename}} }.ecr", "my/app/view/base/path/layouts/layout.ecr"
end
{% endraw %}
```

And now you can use your new renderer.

```ruby
get "/:name" do
  my_renderer "subview"
end
```

# [Filters](#filters)

Before filters are evaluated before each request within the same context as the routes. They can modify the request and response.

_Important note: This should **not** be used by plugins/addons, instead they should do all their work in their own middleware._

Available filters:

 - before\_all, before\_get, before\_post, before\_put, before\_patch, before\_delete
 - after\_all, after\_get, after\_post, after\_put, after\_patch, after\_delete

The `Filter` middleware is lazily added as soon as a call to `after_X` or `before_X` is made. It will __not__ even be instantiated unless a call to `after_X` or `before_X` is made.

When using `before_all` and `after_all` keep in mind that they will be evaluated in the following order:

    before_all -> before_x -> X -> after_x -> after_all


#### [Simple before_get example](#simple-before_get-example)

```ruby
before_get "/foo" do |env|
  puts "Setting response content type"
  env.response.content_type = "application/json"
end

get "/foo" do |env|
  puts env.response.headers["Content-Type"] # => "application/json"
  {"name": "Kemal"}.to_json
end
```

#### [Simple before_all example](#simple-before_all-example)

```ruby
before_all "/foo" do |env|
  puts "Setting response content type"
  env.response.content_type = "application/json"
end

get "/foo" do |env|
  puts env.response.headers["Content-Type"] # => "application/json"
  {"name": "Kemal"}.to_json
end

put "/foo" do |env|
  puts env.response.headers["Content-Type"] # => "application/json"
  {"name": "Kemal"}.to_json
end

post "/foo" do |env|
  puts env.response.headers["Content-Type"] # => "application/json"
  {"name": "Kemal"}.to_json
end

```

#### [Multiple `before_all`](#multiple-before_all)

You can add many blocks to the same verb/path combination by calling it multiple times they will be called __in the same order they were defined__.

```ruby
before_all do |env|
  raise "Unauthorized" unless authorized?(env)
end

before_all do |env|
  env.session = Session.new(env.cookies)
end

get "/foo" do |env|
  "foo"
end

```

Each time `GET /foo` (or any other route since we didn't specify a route for these blocks) is called the first `before_all` will run and then the second will set the session.

_Note: `authorized?` and `Session.new` are fictitious calls used to illustrate the example._

# [Helpers](#helpers)

### [Browser Redirect](#browser-redirect)

Browser redirects are simple as well. Simply call `env.redirect` in the route's corresponding block.

```ruby
# Redirect browser
get "/logout" do |env|
  # important stuff like clearing session etc.
  env.redirect "/login" # redirect to /login page
end
```

**Note:** For configuration options like logging and public folder settings, see the [Configuration](#configuration) section.

### [Halt](#halt)

Halt execution with the current context. Returns 200 and an empty response by default.

```ruby
halt env, status_code: 403, response: "Forbidden"
```

*Note:* `halt` can only be used inside routes.

### [Custom Errors](#custom-errors)

You can customize the built-in error pages or even add your own with `error`.

```ruby
error 404 do
  "This is a customized 404 page."
end

error 403 do
  "Access Forbidden!"
end
```

To handle a custom error based on a raised exception, you pass the exception to `error`

```ruby
get "/" do |env|
  if some_condition
    raise ValueError.new
  end
  {"message": "Hello Kemal"}.to_json
end

error ValueError do
  "Something has gone wrong"
end
```

**NOTE** Exception handlers are resolved based on definition order first, and inheritance order second. For example:

```ruby

class GrandParentException < Exception; end
class ParentException < GrandParentException; end
class ChildException < ParentException; end

error GrandParentException do
  "Grandparent exception"
end

error ParentException do
  "Parent exception"
end

get "/" do
  raise ChildException.new()
end
```

Will resolve to the handler for `GrandParentException` rather than `ParentException`

### [Send File](#send-file)

Send a file with the given path and base the MIME type on the file extension or default to `application/octet-stream`.

```ruby
send_file env, "./path/to/file.jpg"
```

Optionally, you can override the MIME type:

```ruby
send_file env, "./path/to/file.exe", "image/jpeg"
```

For both examples, the file will be sent with the `image/jpeg` MIME type.

MIME type detection is based on the [MIME](https://crystal-lang.org/api/0.27.1/MIME.html) registry from the Crystal standard library, which uses the OS-provided MIME database. If unavailable, it falls back to a basic type list ([MIME::DEFAULT_TYPES](https://crystal-lang.org/api/0.27.1/MIME.html#DEFAULT_TYPES)).

You can extend the registered type list by calling `MIME.register` with an extension and its desired type:

```ruby
MIME.register ".cr", "text/crystal"
```

> **Security Notice:**  
> When using `send_file` with dynamic file paths (such as those based on user input), always **sanitize and validate** the path to prevent directory traversal and unauthorized file access. Never pass unchecked user input directly to `send_file`.  
> For example, ensure the path is within an allowed directory and does not contain sequences like `../` that could escape the intended folder.  
> See [kemalcr/kemal#718](https://github.com/kemalcr/kemal/issues/718) for more details.

# [Middleware](#middleware)

Middleware, also known as `Handler`s, are the building blocks of `Kemal`. Middleware lets you separate application concerns into different layers.

Each middleware is supposed to have one responsibility. Take a look at `Kemal`'s built-in middleware to see what that means.

## [Creating your own middleware](#creating-your-own-middleware)

You can create your own middleware by inheriting from `Kemal::Handler`

```ruby
class CustomHandler < Kemal::Handler
  def call(context)
    puts "Doing some custom stuff here"
    call_next context
  end
end

add_handler CustomHandler.new
```

### [Conditional Middleware Execution](#conditional-middleware-execution)
Kemal gives you access to two handy filters `only` and `exclude`. These can be used to process your custom middleware for `only` specific routes, or to `exclude` from specific routes.

```ruby
class OnlyHandler < Kemal::Handler
  # Matches GET /specials and GET /deals
  only ["/specials", "/deals"]

  def call(env)
    # continue on to next handler unless the request matches the only filter
    return call_next(env) unless only_match?(env)
    puts "If the path is /specials or /deals, I will be doing some processing here."
  end
end

class PostOnlyHandler < Kemal::Handler
  # Matches POST /blogs
  only ["/blogs"], "POST"

  def call(env)
    # call_next is called for GET /blogs, but not POST /blogs
    return call_next(env) unless only_match?(env)
    puts "If the request is a POST to /blogs, I will do some processing here."
  end
end
```

```ruby
class ExcludeHandler < Kemal::Handler
  # Matches GET /
  exclude ["/"]

  def call(env)
    return call_next(env) if exclude_match?(env)
    puts "If the path is not / I will be doing some processing here."
  end
end

class PostExcludeHandler < Kemal::Handler
  # Matches POST /
  exclude ["/"], "POST"

  def call(env)
    return call_next(env) if exclude_match?(env)
    puts "If the request is not a POST to /, I will do some processing here."
  end
end
```

### [Creating a custom Logger middleware](#creating-a-custom-logger-middleware)

You can easily replace the built-in logger of `Kemal`. There's only one requirement which is that
your logger must inherit from `Kemal::BaseLogHandler`.

```ruby
class MyCustomLogger < Kemal::BaseLogHandler
  # This is run for each request. You can access the request/response context with `context`.
  def call(context)
    puts "Custom logger is in action."
    # Be sure to `call_next`.
    call_next context
  end

  def write(message)
  end
end
```

You need to register your custom logger with `logger` config property.

```ruby
require "kemal"

Kemal.config.logger = MyCustomLogger.new
```

That's it!

### [Kemal Middleware](#kemal-middleware)

The Kemal organization has a variety of useful middleware.

- [kemal-basic-auth](https://github.com/kemalcr/kemal-basic-auth): Add HTTP Basic Authorization to your Kemal application.
- [kemal-hmac](https://github.com/kemalcr/kemal-hmac): HMAC middleware for Kemal

# [File Upload](#file-upload)

Kemal provides easy access to uploaded files through `env.params.files`. When a file is uploaded via a form, it's automatically stored in a temporary location and accessible through the parameter name.

## [Basic File Upload](#basic-file-upload)

Here's a simple example of handling file uploads:

```crystal
post "/upload" do |env|
  # Get the uploaded file from the form field named "image"
  file = env.params.files["image"].tempfile
  
  # Create the destination path
  file_path = ::File.join [Kemal.config.public_folder, "uploads/", File.basename(file.path)]
  
  # Copy the uploaded file to the destination
  File.open(file_path, "w") do |f|
    IO.copy(file, f)
  end
  
  "Upload successful!"
end
```

## [Advanced File Upload with Validation](#advanced-file-upload-with-validation)

For production applications, you should validate uploaded files:

```crystal
post "/upload" do |env|
  # Check if file was uploaded
  unless env.params.files.has_key?("image")
    halt env, status_code: 400, response: "No file uploaded"
  end
  
  uploaded_file = env.params.files["image"]
  
  # Validate file size (e.g., max 5MB)
  max_size = 5 * 1024 * 1024
  if uploaded_file.size > max_size
    halt env, status_code: 400, response: "File too large"
  end
  
  # Validate file type by extension
  allowed_extensions = [".jpg", ".jpeg", ".png", ".gif"]
  file_extension = File.extname(uploaded_file.filename || "").downcase
  unless allowed_extensions.includes?(file_extension)
    halt env, status_code: 400, response: "Invalid file type"
  end
  
  # Generate a unique filename to prevent conflicts
  unique_filename = "#{Time.utc.to_unix}_#{uploaded_file.filename}"
  file_path = ::File.join [Kemal.config.public_folder, "uploads/", unique_filename]
  
  # Save the file
  File.open(file_path, "w") do |f|
    IO.copy(uploaded_file.tempfile, f)
  end
  
  "File uploaded successfully as: #{unique_filename}"
end
```

## [File Upload Properties](#file-upload-properties)

The uploaded file object has the following properties:

- `filename`: Original filename of the uploaded file
- `tempfile`: Temporary file object containing the uploaded data
- `size`: Size of the uploaded file in bytes
- `headers`: HTTP headers associated with the file upload

## [Multiple File Upload](#multiple-file-upload)

Kemal also supports uploading multiple files using array notation in form field names:

```crystal
post "/upload-multiple" do |env|
  uploaded_file_names = [] of String
  
  # Get all files from the images[] field
  if env.params.files.has_key?("images[]")
    # env.params.files["images[]"] returns an array of uploaded files
    env.params.files["images[]"].each do |uploaded_file|
      # Validate each file
      max_size = 5 * 1024 * 1024
      if uploaded_file.size > max_size
        next # Skip files that are too large
      end
      
      # Validate file type
      allowed_extensions = [".jpg", ".jpeg", ".png", ".gif"]
      file_extension = File.extname(uploaded_file.filename || "").downcase
      unless allowed_extensions.includes?(file_extension)
        next # Skip invalid file types
      end
      
      # Generate unique filename
      unique_filename = "#{Time.utc.to_unix}_#{Random.rand(1000)}_#{uploaded_file.filename}"
      file_path = ::File.join [Kemal.config.public_folder, "uploads/", unique_filename]
      
      # Save the file
      File.open(file_path, "w") do |f|
        IO.copy(uploaded_file.tempfile, f)
      end
      
      uploaded_file_names << unique_filename
    end
  end
  
  if uploaded_file_names.empty?
    "No valid files were uploaded"
  else
    "Successfully uploaded #{uploaded_file_names.size} files: #{uploaded_file_names.join(", ")}"
  end
end
```

## [Testing File Upload](#testing-file-upload)

You can test single file uploads using `curl`:

```bash
curl -F "image=@/path/to/your/file.png" http://localhost:3000/upload
```

For multiple file uploads:

```bash
curl -F "images[]=@/path/to/file1.png" -F "images[]=@/path/to/file2.jpg" http://localhost:3000/upload-multiple
```

# [Sessions](#sessions)

Kemal supports Sessions with [kemal-session](https://github.com/kemalcr/kemal-session).

```ruby
require "kemal"
require "kemal-session"

get "/set" do |env|
  env.session.int("number", rand(100)) # set the value of "number"
  "Random number set."
end

get "/get" do |env|
  num  = env.session.int("number") # get the value of "number"
  env.session.int?("hello") # get value or nil, like []?
  "Value of random number is #{num}."
end

Kemal.run
```

`kemal-session` has a generic API to multiple storage engines. The default storage engine is `MemoryEngine` which stores the sessions in process memory.
You should ***only*** use `MemoryEngine` for development and testing purposes.

See [kemal-session](https://github.com/kemalcr/kemal-session) for usage and compatible storage engines.

## [Accessing the CSRF token](#accessing-the-csrf-token)

To access the CSRF token of the active session you can do the following in your form:

```erb
<input type="hidden" name="authenticity_token" value="<%= env.session.string("csrf") %>">
```

# [WebSockets](#websockets)

Using *Websockets* with Kemal is super easy!

You can create a `WebSocket` handler which matches the route of `ws://host:port/route`. You can create more than 1 websocket handler
with different routes.

```ruby
ws "/" do |socket|

end

ws "/route2" do |socket|

end
```

Let's access the socket and create a simple echo server.

```ruby
# Matches "/"
ws "/" do |socket|
  # Send welcome message to the client
  socket.send "Hello from Kemal!"

  # Handle incoming message and echo back to the client
  socket.on_message do |message|
    socket.send "Echo back from server #{message}"
  end

  # Executes when the client is disconnected. You can do the cleaning up here.
  socket.on_close do
    puts "Closing socket"
  end
end
```

`ws` yields a second parameter which lets you access the `HTTP::Server::Context` which lets you use the underlying `request` and `response`.

```ruby
ws "/" do |socket, context|
  headers = context.request.headers

  socket.send headers["Content-Type"]?
end
```

### [Accessing Dynamic Url Params](#accessing-dynamic-url-params)

```ruby
ws "/:id" do |socket, context|
  id = context.ws_route_lookup.params["id"]
end
```

# [Testing](#testing)

You can test your Kemal application using [spec-kemal](https://github.com/kemalcr/spec-kemal).

Your Kemal application

```ruby
# src/your-kemal-app.cr

require "kemal"

get "/" do
  "Hello World!"
end

Kemal.run
```

First add `spec-kemal` to your `shard.yml`

```yaml
name: your-kemal-app
version: 0.1.0

dependencies:
  spec-kemal:
    github: kemalcr/spec-kemal
  kemal:
    github: kemalcr/kemal
```

Install dependencies

```
shards install
```

Require it before your files in your `spec/spec_helper.cr`

```ruby
require "spec-kemal"
require "../src/your-kemal-app"
```

Now you can easily test your `Kemal` application in your `spec`s.
Create a file called `spec/your-kemal-app_spec.cr`:

```ruby
require "./spec_helper"

describe "Your::Kemal::App" do

  # You can use get,post,put,patch,delete to call the corresponding route.
  it "renders /" do
    get "/"
    response.body.should eq "Hello World!"
  end

end
```

Run the tests:

```
KEMAL_ENV=test crystal spec
```

# [Static Files](#static-files)

Any files you add to the `public` directory will be served automatically by Kemal.

```
app/
  src/
    your_app.cr
  public/
    js/
      jquery.js
      your_app.js
    css/
      your_app.css
    index.html
```

For example, your index.html may look like this:

```html
<html>
 <head>
   <script src="/js/jquery.js"></script>
   <script src="/js/your_app.js"></script>
   <link rel="stylesheet" href="/css/your_app.css"/>
 </head>
 <body>
   ...
 </body>
</html>
```

Kemal will serve the files in the `public` directory without having to write routes for them.

**Note:** For configuration options like changing the public folder, disabling static files, adding custom headers, or configuring gzip and directory listing, see the [Static Files Configuration](#static-files-configuration) section.

# [Configuration](#configuration)

Kemal provides a powerful configuration system through `Kemal.config` that allows you to customize various aspects of your application. Here are all the available public configuration options:

## [Server Configuration](#server-configuration)

### [Host and Port](#host-and-port)

Configure the host address and port your application listens on:

```ruby
Kemal.config.host_binding = "127.0.0.1"  # Default: "0.0.0.0"
Kemal.config.port = 8080                  # Default: 3000
```

You can also set these via command line flags:

```bash
./your_app --bind 127.0.0.1 --port 8080
```

### [Max Request Body Size](#max-request-body-size)

Limit the maximum size of HTTP request bodies to prevent potential memory exhaustion or DoS attacks:

```ruby
Kemal.config.max_request_body_size = 1024 * 1024 * 10  # 10 MB (in bytes)
# Default: 8 MB
```

When a request exceeds this limit, Kemal will reject it with a `413 Payload Too Large` response. This is particularly useful for:

- **File uploads**: Prevent users from uploading excessively large files
- **API endpoints**: Protect against malicious payloads
- **Memory management**: Avoid memory exhaustion from large requests

Example with different limits for different purposes:

```ruby
# For API with JSON payloads
Kemal.config.max_request_body_size = 1024 * 100  # 100 KB

# For file upload applications
Kemal.config.max_request_body_size = 1024 * 1024 * 50  # 50 MB

# No limit (use with caution in production)
Kemal.config.max_request_body_size = nil
```

**Note:** Setting this value too low may prevent legitimate large requests from being processed. Choose a value that balances security with your application's requirements.

## [Static Files Configuration](#static-files-configuration)

### [Public Folder](#public-folder)

Set the directory for serving static files:

```ruby
Kemal.config.public_folder = "./assets"  # Default: "./public"
```

### [Serve Static Files](#serve-static-files)

Enable or disable static file serving:

```ruby
Kemal.config.serve_static = false  # Default: true
```

You can also pass options for gzip compression and directory listing:

```ruby
Kemal.config.serve_static = {"gzip" => true, "dir_listing" => false}
```

By default `Kemal` gzips most files, skipping only very small files, or those which don't benefit from gzipping. If you are running `Kemal` behind a proxy, you may wish to disable this feature.

### [Static Headers](#static-headers)

Add custom headers to static files served by `Kemal::StaticFileHandler`. This is especially useful for CORS or caching:

```ruby
static_headers do |response, filepath, filestat|
  if filepath =~ /\.html$/
    response.headers.add("Access-Control-Allow-Origin", "*")
  end
  response.headers.add("Content-Size", filestat.size.to_s)
end
```

## [Logging Configuration](#logging-configuration)

### [Enable/Disable Logging](#enable-disable-logging)

Kemal enables logging by default. You can easily disable it:

```ruby
Kemal.config.logging = false  # Default: true
```

You can add logging statements to your code:

```ruby
Log.info { "Log message with or without embedded #{variables}" }
```

### [Custom Logger](#custom-logger)

You can easily replace the built-in logger of `Kemal`. Your logger must inherit from `Kemal::BaseLogHandler`:

```ruby
class MyCustomLogger < Kemal::BaseLogHandler
  # This is run for each request. You can access the request/response context with `context`.
  def call(context)
    puts "Custom logger is in action."
    # Be sure to `call_next`.
    call_next context
  end

  def write(message)
  end
end
```

Register your custom logger with the `logger` config property:

```ruby
require "kemal"

Kemal.config.logger = MyCustomLogger.new
```

## [SSL Configuration](#ssl-configuration)

Configure SSL/TLS for HTTPS:

```ruby
Kemal.config.ssl = true
Kemal.config.ssl_certificate_file = "/path/to/cert.pem"
Kemal.config.ssl_key_file = "/path/to/key.pem"
```

Or use command line flags:

```bash
./your_app --ssl --ssl-cert-file cert.pem --ssl-key-file key.pem
```

## [Environment Configuration](#environment-configuration)

Kemal respects the `KEMAL_ENV` environment variable and `Kemal.config.env`. It is set to `development` by default.

To change this value to `production`, for example, use:

```bash
$ export KEMAL_ENV=production
```

If you prefer to do this from within your application, use:

```ruby
Kemal.config.env = "production"
```

When the `KEMAL_ENV` environment variable is not set to `production`, e.g. `development`, an exception page is rendered when an exception is raised which provides a lot of useful information for debugging. However, if the environment variable is set to `production` a standard error page is rendered (see [source](https://github.com/kemalcr/kemal/blob/master/src/kemal/helpers/exception_page.cr#L16)).

**Note:** `KEMAL_ENV` should ***always*** be set to `production` in a production environment for security reasons.

## [Error Handling](#error-handling)

### [Powered By Header](#powered-by-header)

Hide or customize the "X-Powered-By" header:

```ruby
Kemal.config.powered_by_header = false       # Disable header
Kemal.config.powered_by_header = "MyApp"     # Custom value
# Default: "Kemal"
```

### [Always Rescue](#always-rescue)

Control whether Kemal should rescue all exceptions:

```ruby
Kemal.config.always_rescue = false  # Default: true
```

When set to `false`, exceptions will not be caught by Kemal's exception handler and will propagate up.

## [Handler Configuration](#handler-configuration)

### [Add Custom Handlers](#add-custom-handlers)

Add custom middleware/handlers to your application:

```ruby
Kemal.config.add_handler MyCustomHandler.new
```

Handlers are added in the order they're called and will be executed in that order for each request.

### [Extra Options](#extra-options)

Store custom application-wide configuration:

```ruby
Kemal.config.extra_options do |parser|
  parser.on("-c CONFIG", "--config CONFIG", "Load configuration from file") do |config_file|
    # Your custom logic here
  end
end
```

## [Server Instance Configuration](#server-instance-configuration)

### [Customize HTTP Server](#customize-http-server)

Access and configure the underlying `HTTP::Server` instance:

```ruby
Kemal.config.server.not_nil!.bind_tcp "0.0.0.0", 3000, reuse_port: true
```

### [Shutdown Timeout](#shutdown-timeout)

Configure graceful shutdown timeout:

```ruby
Kemal.config.shutdown_timeout = 10.seconds  # Default: nil (no timeout)
```

## [Complete Configuration Example](#complete-configuration-example)

Here's a comprehensive example showing multiple configuration options:

```ruby
require "kemal"

# Server settings
Kemal.config.host_binding = "0.0.0.0"
Kemal.config.port = 3000
Kemal.config.env = "production"
Kemal.config.max_request_body_size = 1024 * 1024 * 10  # 10 MB limit

# Static files
Kemal.config.public_folder = "./public"
Kemal.config.serve_static = {"gzip" => true, "dir_listing" => false}

# Logging
Kemal.config.logging = true

# SSL
Kemal.config.ssl = true
Kemal.config.ssl_certificate_file = "./ssl/cert.pem"
Kemal.config.ssl_key_file = "./ssl/key.pem"

# Headers
Kemal.config.powered_by_header = "MyApp/1.0"

# Error handling
Kemal.config.always_rescue = true

# Add custom handler
Kemal.config.add_handler MyAuthHandler.new

# Your routes go here
get "/" do
  "Hello World!"
end

Kemal.run
```

## [Configuration Priority](#configuration-priority)

Configuration values are resolved in the following order (highest to lowest priority):

1. Command-line arguments (`--port`, `--bind`, etc.)
2. Code configuration (`Kemal.config.port = 3000`)
3. Environment variables (`KEMAL_ENV`)
4. Default values

## [Helper Methods vs Config Methods](#helper-methods-vs-config-methods)

Kemal provides two equivalent ways to configure most options:

**Helper methods (shorthand):**

```ruby
logging false
public_folder "./assets"
serve_static false
```

**Config object (explicit):**

```ruby
Kemal.config.logging = false
Kemal.config.public_folder = "./assets"
Kemal.config.serve_static = false
```

Both approaches are valid and produce the same result. Use whichever style fits your preference.

# [CLI](#cli)

A Kemal application accepts a few optional command-line flags:

| Short flag | Long flag              | Description                                   |
|------------| -----------------------| --------------------------------------------- |
| `-b HOST`  | `--bind HOST`          | Host to bind (default: 0.0.0.0)               |
| `-p PORT`  | `--port PORT`          | Port to listen for connection (default: 3000) |
| `-s`       | `--ssl`                | Enables SSL                                   |
|            | `--ssl-key-file FILE`  | SSL key file                                  |
|            | `--ssl-cert-file FILE` | SSL certificate file                          |
{:.mbtablestyle}

**Note:** For detailed configuration options and programmatic configuration, see the [Configuration](#configuration) section.

# [SSL](#ssl)

Kemal has built-in and easy to use SSL support.

To start your Kemal with SSL support.

```
crystal build --release src/your_app.cr
./your_app --ssl --ssl-key-file your_key_file --ssl-cert-file your_cert_file
```

# [Security](#security)

Best practices for securing your Kemal application: resource limits, security headers, rate limiting, and the Defense shard for throttling and blocking malicious requests.

## [Resource Limits](#resource-limits)

**Set appropriate limits:**

```ruby
require "kemal"

# Maximum request body size (10 MB)
Kemal.config.max_request_body_size = 10 * 1024 * 1024

# Powered by header (hide for security)
Kemal.config.powered_by_header = false

# Always rescue in production
Kemal.config.always_rescue = true
```

## [Defense](#defense)

[Defense](https://github.com/defense-cr/defense) is a Crystal HTTP handler for throttling, blocking and tracking malicious requests (inspired by Rack::Attack). Add the shard and register the handler early in your handler chain:

```ruby
# shard.yml
dependencies:
  defense:
    github: defense-cr/defense
```

```ruby
require "kemal"
require "defense"

# Store: Redis (production) or MemoryStore (development/tests)
Defense.store = Defense::RedisStore.new(url: ENV["REDIS_URL"]? || "redis://localhost:6379/0")
# Defense.store = Defense::MemoryStore.new

add_handler Defense::Handler.new

# Throttle: 10 requests per minute per IP
Defense.throttle("requests per minute", limit: 10, period: 60) do |request|
  request.remote_address.to_s
end

# Blocklist: block /admin for non-trusted IPs
Defense.blocklist("block admin") do |request|
  request.path.starts_with?("/admin/")
end

# Safelist: never throttle/block localhost
Defense.safelist("localhost") do |request|
  request.remote_address.to_s == "127.0.0.1"
end

get "/" do
  "Hello World"
end

Kemal.run
```

Throttled and blocked responses are configurable via `Defense.throttled_response=` and `Defense.blocked_response=`. Defense also supports Fail2Ban and Allow2Ban for banning after repeated violations. See the [Defense README](https://github.com/defense-cr/defense) for full options.

# [Deployment](#deployment)

Deploying a Kemal application to production requires careful consideration of build optimization, hosting platform, infrastructure setup, and operational best practices. This comprehensive guide covers everything you need to know to deploy your Kemal application successfully.

## [Production Build](#production-build)

Before deploying your Kemal application, you need to compile it for production with optimizations enabled.

### [Basic Release Build](#basic-release-build)

Create an optimized production binary:

```bash
crystal build --release --no-debug src/your_app.cr
```

**Flags explained:**
- `--release`: Enables optimizations and removes runtime checks
- `--no-debug`: Strips debug information, reducing binary size

### [Static Linking](#static-linking)

For maximum portability (especially for containers or cross-platform deployment), use static linking:

```bash
crystal build --release --static --no-debug src/your_app.cr
```

The `--static` flag links all dependencies statically, producing a single binary with no external dependencies. This is ideal for Alpine Linux containers.

### [Build Optimization Tips](#build-optimization-tips)

**Reduce binary size:**

```bash
# Strip additional symbols
strip your_app

# Enable link-time optimization
crystal build --release --no-debug -Dpreview_mt src/your_app.cr
```

**Environment-specific builds:**

```bash
# Set production environment during compilation
KEMAL_ENV=production crystal build --release src/your_app.cr
```

## [Docker Deployment](#docker-deployment)

Docker provides consistent, reproducible deployments across different environments.

### [Multi-Stage Dockerfile](#multi-stage-dockerfile)

Create a `Dockerfile` in your project root:

```dockerfile
# Build stage
FROM crystallang/crystal:1.11.2-alpine AS builder

WORKDIR /app

# Copy shard files
COPY shard.yml shard.lock ./

# Install dependencies
RUN shards install --production

# Copy source code
COPY . .

# Build the application
RUN crystal build --release --static --no-debug src/your_app.cr -o bin/app

# Runtime stage
FROM alpine:latest

WORKDIR /app

# Install runtime dependencies (if needed)
RUN apk add --no-cache libgcc

# Copy compiled binary from builder
COPY --from=builder /app/bin/app .

# Copy public assets (if any)
COPY --from=builder /app/public ./public

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# Run the application
CMD ["./app"]
```

### [.dockerignore](#dockerignore)

Create a `.dockerignore` file to exclude unnecessary files:

```
.git
.github
*.md
spec
lib
shard.lock
tmp
log
*.log
.env
.env.*
node_modules
.DS_Store
```

### [Docker Compose](#docker-compose)

For local development and testing with dependencies:

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      KEMAL_ENV: production
      DATABASE_URL: postgres://postgres:password@db:5432/myapp
      REDIS_URL: redis://redis:6379
    depends_on:
      - db
      - redis
    restart: unless-stopped

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

### [Building and Running](#building-and-running)

```bash
# Build the image
docker build -t my-kemal-app .

# Run the container
docker run -p 3000:3000 -e KEMAL_ENV=production my-kemal-app

# Using Docker Compose
docker-compose up -d
```

## [Cloud Platforms](#cloud-platforms)

Deploy your Kemal application to popular cloud platforms with ease.

### [Heroku](#heroku)

[Heroku](https://www.heroku.com/) provides a simple deployment experience with the official Crystal buildpack.

**Setup:**

1. Create a `Procfile` in your project root:

```
web: ./your_app --port $PORT --bind 0.0.0.0
```

2. Add the Crystal buildpack:

```bash
heroku buildpacks:set https://github.com/crystal-lang/heroku-buildpack-crystal
```

3. Deploy:

```bash
git push heroku main
```

**Configuration:**

```bash
# Set environment variables
heroku config:set KEMAL_ENV=production

# Add database
heroku addons:create heroku-postgresql:mini

# Scale dynos
heroku ps:scale web=1
```

**Important:** Configure your app to use the `PORT` environment variable:

```ruby
Kemal.config.port = ENV["PORT"]?.try(&.to_i) || 3000
Kemal.config.host_binding = ENV["HOST"]? || "0.0.0.0"
```

### [Fly.io](#flyio)

[Fly.io](https://fly.io/) offers excellent support for Crystal applications with their global deployment network.

**Setup:**

1. Install the Fly CLI and authenticate:

```bash
curl -L https://fly.io/install.sh | sh
fly auth login
```

2. Initialize your app:

```bash
fly launch
```

3. Create a `fly.toml` configuration:

```toml
app = "my-kemal-app"
primary_region = "iad"

[build]
  image = "your-registry/my-kemal-app:latest"

[env]
  KEMAL_ENV = "production"

[http_service]
  internal_port = 3000
  force_https = true
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 1

[[services]]
  protocol = "tcp"
  internal_port = 3000

  [[services.ports]]
    port = 80
    handlers = ["http"]

  [[services.ports]]
    port = 443
    handlers = ["tls", "http"]

[checks]
  [checks.health]
    grace_period = "5s"
    interval = "30s"
    method = "get"
    path = "/health"
    timeout = "2s"
```

4. Deploy:

```bash
fly deploy
```

**Add PostgreSQL:**

```bash
fly postgres create
fly postgres attach my-postgres-db
```

### [Render](#render)

[Render](https://render.com/) provides managed deployments with automatic SSL and CDN.

**Setup:**

Create a `render.yaml` file:

```yaml
services:
  - type: web
    name: my-kemal-app
    env: docker
    plan: starter
    dockerfilePath: ./Dockerfile
    healthCheckPath: /health
    envVars:
      - key: KEMAL_ENV
        value: production
      - key: DATABASE_URL
        fromDatabase:
          name: myapp-db
          property: connectionString
    autoDeploy: true

databases:
  - name: myapp-db
    plan: starter
    databaseName: myapp
    user: myapp
```

**Deploy:**

1. Connect your GitHub/GitLab repository
2. Render will automatically detect `render.yaml` and deploy
3. Every push to main branch triggers automatic deployment

### [Railway](#railway)

[Railway](https://railway.app/) offers simple deployments with automatic configuration detection.

**Setup:**

1. Install Railway CLI:

```bash
npm i -g @railway/cli
railway login
```

2. Initialize and deploy:

```bash
railway init
railway up
```

Railway automatically detects Crystal applications and builds them appropriately.

**Add services:**

```bash
railway add postgres
railway add redis
```

**Environment variables are automatically injected** for added services.

### [DigitalOcean App Platform](#digitalocean-app-platform)

[DigitalOcean App Platform](https://www.digitalocean.com/products/app-platform) provides managed container deployments.

**Setup:**

Create an `.do/app.yaml` file:

```yaml
name: my-kemal-app
services:
  - name: web
    dockerfile_path: Dockerfile
    github:
      repo: username/repo
      branch: main
      deploy_on_push: true
    health_check:
      http_path: /health
    http_port: 3000
    instance_count: 1
    instance_size_slug: basic-xxs
    routes:
      - path: /
    envs:
      - key: KEMAL_ENV
        value: production
      - key: DATABASE_URL
        scope: RUN_TIME
        type: SECRET

databases:
  - name: db
    engine: PG
    production: false
```

**Deploy via CLI:**

```bash
doctl apps create --spec .do/app.yaml
```

## [VPS and Bare Metal Deployment](#vps-bare-metal)

For full control over your infrastructure, deploy to a VPS or bare metal server.

### [Server Setup](#server-setup)

**Prerequisites:**

- Ubuntu 22.04 LTS (or similar Linux distribution)
- Non-root user with sudo privileges
- Domain name pointing to your server's IP

### [Systemd Service](#systemd-service)

Create a systemd service to manage your Kemal application.

**1. Upload your compiled binary:**

```bash
# On your development machine
scp your_app user@server:/opt/myapp/

# On the server
sudo mkdir -p /opt/myapp
sudo chown -R www-data:www-data /opt/myapp
```

**2. Create a systemd service file:**

Create `/etc/systemd/system/kemal-app.service`:

```ini
[Unit]
Description=Kemal Application
After=network.target postgresql.service

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=/opt/myapp
ExecStart=/opt/myapp/your_app
Restart=always
RestartSec=10

# Environment variables
Environment=KEMAL_ENV=production
Environment=PORT=3000
Environment=HOST=127.0.0.1

# Environment file for secrets
EnvironmentFile=/opt/myapp/.env

# Security hardening
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/myapp/log /opt/myapp/tmp

# Resource limits
LimitNOFILE=65535
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
```

**3. Create environment file:**

Create `/opt/myapp/.env`:

```bash
DATABASE_URL=postgres://user:password@localhost/myapp
REDIS_URL=redis://localhost:6379
SECRET_KEY_BASE=your-secret-key-here
```

**4. Enable and start the service:**

```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable service to start on boot
sudo systemctl enable kemal-app

# Start the service
sudo systemctl start kemal-app

# Check status
sudo systemctl status kemal-app

# View logs
sudo journalctl -u kemal-app -f
```

**Service management commands:**

```bash
# Restart the service
sudo systemctl restart kemal-app

# Stop the service
sudo systemctl stop kemal-app

# Reload service configuration
sudo systemctl daemon-reload
sudo systemctl restart kemal-app
```

### [Nginx Reverse Proxy](#nginx-reverse-proxy)

Use Nginx as a reverse proxy to handle SSL termination, static file serving, and load balancing.

**1. Install Nginx:**

```bash
sudo apt update
sudo apt install nginx
```

**2. Create Nginx configuration:**

Create `/etc/nginx/sites-available/myapp`:

```nginx
upstream kemal {
    # Multiple instances for load balancing (optional)
    server 127.0.0.1:3000 max_fails=3 fail_timeout=30s;
    # server 127.0.0.1:3001 max_fails=3 fail_timeout=30s;
    # server 127.0.0.1:3002 max_fails=3 fail_timeout=30s;
    
    keepalive 32;
}

# HTTP server - redirect to HTTPS
server {
    listen 80;
    listen [::]:80;
    server_name example.com www.example.com;
    
    # ACME challenge for Let's Encrypt
    location ^~ /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
    
    # Redirect all HTTP to HTTPS
    location / {
        return 301 https://$server_name$request_uri;
    }
}

# HTTPS server
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name example.com www.example.com;
    
    # SSL configuration
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/example.com/chain.pem;
    
    # SSL settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # Security headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # Logging
    access_log /var/log/nginx/myapp-access.log;
    error_log /var/log/nginx/myapp-error.log;
    
    # Max upload size
    client_max_body_size 50M;
    
    # Serve static files directly (if applicable)
    location /static/ {
        alias /opt/myapp/public/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
    
    # WebSocket support
    location /ws {
        proxy_pass http://kemal;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 86400;
    }
    
    # Proxy to Kemal application
    location / {
        proxy_pass http://kemal;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Connection "";
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # Buffering
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
    }
    
    # Health check endpoint
    location /health {
        proxy_pass http://kemal;
        access_log off;
    }
}
```

**3. Enable the site:**

```bash
# Create symbolic link
sudo ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

### [SSL with Let's Encrypt](#ssl-lets-encrypt)

Secure your application with free SSL certificates from Let's Encrypt.

**1. Install Certbot:**

```bash
sudo apt install certbot python3-certbot-nginx
```

**2. Obtain SSL certificate:**

```bash
# Create webroot directory
sudo mkdir -p /var/www/certbot

# Obtain certificate
sudo certbot --nginx -d example.com -d www.example.com
```

**3. Auto-renewal:**

Certbot automatically creates a renewal timer. Verify it:

```bash
# Test renewal
sudo certbot renew --dry-run

# Check timer status
sudo systemctl status certbot.timer
```

**Manual renewal hook (optional):**

Create `/etc/letsencrypt/renewal-hooks/deploy/reload-nginx.sh`:

```bash
#!/bin/bash
systemctl reload nginx
```

```bash
sudo chmod +x /etc/letsencrypt/renewal-hooks/deploy/reload-nginx.sh
```

### [Log Rotation](#log-rotation)

Configure log rotation to prevent disk space issues.

Create `/etc/logrotate.d/kemal-app`:

```
/opt/myapp/log/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 www-data www-data
    sharedscripts
    postrotate
        systemctl reload kemal-app > /dev/null 2>&1 || true
    endscript
}
```

## [Production Best Practices](#production-best-practices)

Follow these best practices to ensure a robust production deployment.

### [Environment Configuration](#environment-configuration)

**Use environment variables for configuration:**

```ruby
require "kemal"

# Configuration from environment
Kemal.config.env = ENV["KEMAL_ENV"]? || "development"
Kemal.config.port = ENV["PORT"]?.try(&.to_i) || 3000
Kemal.config.host_binding = ENV["HOST"]? || "0.0.0.0"

# Database configuration
DATABASE_URL = ENV["DATABASE_URL"]? || "postgres://localhost/myapp_dev"

# Secret key for sessions, tokens, etc.
SECRET_KEY = ENV["SECRET_KEY_BASE"]? || raise "SECRET_KEY_BASE is required"

# Feature flags
ENABLE_FEATURE_X = ENV["ENABLE_FEATURE_X"]? == "true"
```

**Never commit secrets to version control:**

```bash
# .gitignore
.env
.env.*
!.env.example
config/secrets.yml
```

**Provide an example environment file:**

Create `.env.example`:

```bash
KEMAL_ENV=production
PORT=3000
HOST=0.0.0.0
DATABASE_URL=postgres://user:password@localhost/myapp
REDIS_URL=redis://localhost:6379
SECRET_KEY_BASE=generate-a-secure-random-string-here
```

### [Logging and Monitoring](#logging-monitoring)

**Configure production logging:**

```ruby
require "kemal"

# Set environment
Kemal.config.env = ENV["KEMAL_ENV"]? || "production"

# Enable logging
Kemal.config.logging = true

# Use structured logging
Log.setup do |c|
  backend = Log::IOBackend.new
  
  if Kemal.config.env == "production"
    # JSON logging for production
    backend.formatter = Log::Formatter.new do |entry, io|
      {
        timestamp: Time.utc,
        level: entry.severity.to_s,
        message: entry.message,
        source: entry.source
      }.to_json(io)
    end
    c.bind "*", :info, backend
  else
    # Human-readable for development
    c.bind "*", :debug, backend
  end
end
```

**Application logging:**

```ruby
# Use Crystal's Log
Log.info { "User #{user_id} logged in" }
Log.warn { "Rate limit exceeded for IP #{ip}" }
Log.error { "Database connection failed: #{error}" }
```

**Monitor application health:**

```ruby
# Add health check endpoint
get "/health" do |env|
  env.response.content_type = "application/json"
  
  # Check database connectivity
  db_healthy = begin
    DB.open(DATABASE_URL) { |db| db.query_one("SELECT 1", as: Int32) }
    true
  rescue
    false
  end
  
  # Check Redis connectivity
  redis_healthy = begin
    Redis.new(url: REDIS_URL).ping
    true
  rescue
    false
  end
  
  status = db_healthy && redis_healthy ? "healthy" : "unhealthy"
  env.response.status_code = status == "healthy" ? 200 : 503
  
  {
    status: status,
    timestamp: Time.utc.to_rfc3339,
    checks: {
      database: db_healthy ? "up" : "down",
      redis: redis_healthy ? "up" : "down"
    }
  }.to_json
end

# Readiness check (for Kubernetes)
get "/ready" do |env|
  env.response.content_type = "application/json"
  {"status" => "ready"}.to_json
end

# Liveness check (for Kubernetes)
get "/live" do |env|
  env.response.content_type = "application/json"
  {"status" => "alive"}.to_json
end
```

### [Graceful Shutdown](#graceful-shutdown)

Ensure your application shuts down gracefully, completing in-flight requests.

```ruby
require "kemal"

# Configure graceful shutdown
Kemal.config.shutdown_timeout = 10.seconds

# Handle shutdown signals
Signal::INT.trap do
  Log.info { "Received SIGINT, shutting down gracefully..." }
  Kemal.stop
  exit
end

Signal::TERM.trap do
  Log.info { "Received SIGTERM, shutting down gracefully..." }
  Kemal.stop
  exit
end

# Your routes...
get "/" do
  "Hello World"
end

Kemal.run
```

## [Deployment Strategies](#deployment-strategies)

### [Zero-Downtime Deployment](#zero-downtime-deployment)

Deploy new versions without service interruption.

**Using Nginx upstream:**

Update your Nginx configuration to use multiple upstream servers:

```nginx
upstream kemal {
    server 127.0.0.1:3000;
    server 127.0.0.1:3001;
    server 127.0.0.1:3002;
}
```

**Deployment script:**

Create `scripts/deploy.sh`:

```bash
#!/bin/bash
set -e

APP_DIR="/opt/myapp"
PORTS=(3000 3001 3002)

echo "Building new version..."
crystal build --release --no-debug src/your_app.cr -o your_app.new

echo "Deploying with zero downtime..."
for PORT in "${PORTS[@]}"; do
    echo "Deploying to instance on port $PORT..."
    
    # Replace binary
    mv your_app.new $APP_DIR/your_app
    
    # Restart instance
    sudo systemctl restart kemal-app-$PORT
    
    # Wait for health check
    sleep 5
    
    # Check if healthy
    if curl -f http://localhost:$PORT/health > /dev/null 2>&1; then
        echo "Instance on port $PORT is healthy"
    else
        echo "Instance on port $PORT failed health check!"
        exit 1
    fi
    
    # Wait before next instance
    sleep 2
done

echo "Deployment complete!"
```

### [Running Multiple Instances](#running-multiple-instances)

Use `reuse_port` to run multiple instances on the same port.

**Enable SO_REUSEPORT:**

```ruby
require "kemal"

# Configure the server to reuse the port
Kemal.config.server.not_nil!.bind_tcp(
  Kemal.config.host_binding,
  Kemal.config.port,
  reuse_port: true
)

# Your routes...
get "/" do
  "Hello from process #{Process.pid}"
end

Kemal.run
```

**Create multiple systemd services:**

```bash
# Create service instances
sudo systemctl enable kemal-app@{1,2,3,4}
sudo systemctl start kemal-app@{1,2,3,4}
```

Or use a single service with increased process count:

```ini
[Unit]
Description=Kemal Application
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/myapp
ExecStart=/opt/myapp/your_app
Restart=always

# Run 4 instances
Environment=GOMAXPROCS=4
EnvironmentFile=/opt/myapp/.env

[Install]
WantedBy=multi-user.target
```

## [Database Migrations](#database-migrations)

Integrate database migrations into your deployment workflow.

**Pre-deployment migration script:**

```bash
#!/bin/bash
set -e

echo "Running database migrations..."

# Using Micrate (Crystal migration tool)
DATABASE_URL=$DATABASE_URL ./bin/micrate up

if [ $? -eq 0 ]; then
    echo "Migrations completed successfully"
else
    echo "Migration failed!"
    exit 1
fi
```

**Safe migration practices:**

```ruby
# migrations/001_add_users_table.sql
-- Always use IF NOT EXISTS for safety
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

# migrations/002_add_index.sql
-- Create indexes concurrently (PostgreSQL)
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_users_email ON users(email);
```

**Include in deployment:**

```bash
# Deploy script with migrations
./scripts/migrate.sh && \
./scripts/deploy.sh
```

## [Continuous Deployment](#continuous-deployment)

Automate your deployment process with CI/CD pipelines.

### [GitHub Actions](#github-actions)

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Install Crystal
        uses: crystal-lang/install-crystal@v1
        with:
          crystal: latest
      
      - name: Install dependencies
        run: shards install
      
      - name: Run tests
        run: crystal spec
        env:
          DATABASE_URL: postgres://postgres:postgres@localhost/test
  
  build:
    needs: test
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Login to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.repository }}:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max
  
  deploy:
    needs: build
    runs-on: ubuntu-latest
    
    steps:
      - name: Deploy to production
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd /opt/myapp
            docker pull ghcr.io/${{ github.repository }}:latest
            docker-compose up -d
            docker system prune -f
```

### [GitLab CI/CD](#gitlab-cicd)

Create `.gitlab-ci.yml`:

```yaml
stages:
  - test
  - build
  - deploy

variables:
  DOCKER_IMAGE: $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

test:
  stage: test
  image: crystallang/crystal:latest
  services:
    - postgres:15
  variables:
    POSTGRES_DB: test
    POSTGRES_USER: postgres
    POSTGRES_PASSWORD: postgres
    DATABASE_URL: postgres://postgres:postgres@postgres/test
  script:
    - shards install
    - crystal spec
  only:
    - main
    - merge_requests

build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $DOCKER_IMAGE .
    - docker push $DOCKER_IMAGE
    - docker tag $DOCKER_IMAGE $CI_REGISTRY_IMAGE:latest
    - docker push $CI_REGISTRY_IMAGE:latest
  only:
    - main

deploy:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache openssh-client
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan $SERVER_HOST >> ~/.ssh/known_hosts
  script:
    - |
      ssh $SERVER_USER@$SERVER_HOST << EOF
        cd /opt/myapp
        docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
        docker pull $DOCKER_IMAGE
        docker-compose up -d
        docker system prune -f
      EOF
  only:
    - main
  environment:
    name: production
    url: https://example.com
```

## [Performance Tuning](#performance-tuning)

Optimize your Kemal application for maximum performance.

### [Static File Serving](#static-file-serving)

For better performance, serve static files with Nginx instead of Kemal:

```ruby
# Disable Kemal's static file handler in production
if Kemal.config.env == "production"
  Kemal.config.serve_static = false
end
```

Then configure Nginx to serve static files directly:

```nginx
location /assets/ {
    alias /opt/myapp/public/assets/;
    expires 1y;
    add_header Cache-Control "public, immutable";
    access_log off;
}
```

### [Gzip Compression](#gzip-compression)

Enable gzip compression in Nginx for text-based responses:

```nginx
# Enable gzip
gzip on;
gzip_vary on;
gzip_proxied any;
gzip_comp_level 6;
gzip_types text/plain text/css text/xml text/javascript 
           application/json application/javascript application/xml+rss 
           application/rss+xml font/truetype font/opentype 
           application/vnd.ms-fontobject image/svg+xml;
gzip_disable "msie6";
```

### [Connection Pooling](#connection-pooling)

Use connection pooling for database connections:

```ruby
require "db"
require "pg"

# Create connection pool
DB_POOL = DB.open(ENV["DATABASE_URL"]) do |conn|
  conn.max_pool_size = 25
  conn.initial_pool_size = 5
  conn.max_idle_pool_size = 10
  conn.checkout_timeout = 5.0
  conn.retry_attempts = 3
  conn.retry_delay = 1.0
end

# Use in routes
get "/users" do |env|
  users = DB_POOL.query_all("SELECT * FROM users", as: User)
  users.to_json
end
```

### [Caching Strategies](#caching-strategies)

Implement caching for expensive operations:

```ruby
require "redis"

# Initialize Redis
REDIS = Redis.new(url: ENV["REDIS_URL"])

# Cache expensive queries
get "/popular-posts" do |env|
  cache_key = "popular_posts"
  
  # Try cache first
  cached = REDIS.get(cache_key)
  if cached
    env.response.content_type = "application/json"
    next cached
  end
  
  # Compute if not cached
  posts = DB.query_all("SELECT * FROM posts ORDER BY views DESC LIMIT 10", as: Post)
  result = posts.to_json
  
  # Cache for 5 minutes
  REDIS.setex(cache_key, 300, result)
  
  env.response.content_type = "application/json"
  result
end
```

### [HTTP/2 and Keep-Alive](#http2-keepalive)

Enable HTTP/2 in Nginx for better performance:

```nginx
listen 443 ssl http2;
listen [::]:443 ssl http2;

# Keep-alive settings
keepalive_timeout 65;
keepalive_requests 100;
```

## [Capistrano](#capistrano)

For traditional deployment workflows, you can use [capistrano-kemal](https://github.com/sdogruyol/capistrano-kemal) to deploy your Kemal application to any server with automated deployment scripts.

## [Cross-compilation](#cross-compilation)

Cross-compile your Kemal application for different platforms.

**Basic cross-compilation:**

```bash
# Compile for Linux (from macOS)
crystal build --cross-compile --target x86_64-unknown-linux-gnu src/your_app.cr
```

This generates a `.o` file and a linker command. You'll need to run the linker command on the target platform.

**Docker-based cross-compilation:**

A more practical approach is using Docker:

```bash
# Create a builder container
docker run --rm -v $(pwd):/app -w /app crystallang/crystal:latest \
  crystal build --release --static --no-debug src/your_app.cr -o bin/app-linux
```

**Multi-platform Docker builds:**

```bash
# Build for multiple architectures
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 -t myapp:latest .
```

For more details, see the official [Crystal cross-compilation guide](http://crystal-lang.org/docs/syntax_and_semantics/cross-compilation.html).

### [Improve this guide](#improve-this-guide)

Please help us improve this guide with pull requests to [this website repository](https://github.com/kemalcr/kemalcr.com).
