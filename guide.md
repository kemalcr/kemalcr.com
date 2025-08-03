---
layout: default
title: Kemal - Guide
---

# [Getting Started](#getting-started)

This guide assumes that you already have Crystal installed. If not, check out the [Crystal installation methods](https://crystal-lang.org/install/) and come back when you're done.

### Installing Kemal

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
Installing kemal (0.21.0)
```

That's it! You're now ready to use Kemal in your application.

### Using Kemal

You can do awesome stuff with Kemal. Let's start with a simple example. Just change the content of `src/your_app.cr` to:

```ruby
require "kemal"

get "/" do
  "Hello World!"
end

Kemal.run
```

### Running Kemal

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
get "/" do
.. show something ..
end

post "/" do
.. create something ..
end

put "/" do
.. replace something ..
end

patch "/" do
.. modify something ..
end

delete "/" do
.. annihilate something ..
end
```
Any **string** returned from a route will output to the browser.
Routes are matched in the order they are defined. The first route that matches the request is invoked.

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

## Static File Options

### Disabling Static Files

By default `Kemal` serves static files from `public` folder.
If you don't need static file serving at all(for example an API doesn't need static file serving) you can disable it via

```ruby
serve_static false
```

### Static Headers

Adds headers to `Kemal::StaticFileHandler`. This is especially useful for stuff like `CORS` or caching.

```ruby
static_headers do |response, filepath, filestat|
  if filepath =~ /\.html$/
    response.headers.add("Access-Control-Allow-Origin", "*")
  end
  response.headers.add("Content-Size", filestat.size.to_s)
end
```

### Modifying Other Options

By default `Kemal` gzips most files, skipping only very small files, or those which don't benefit from gzipping.

If you are running `Kemal` behind a proxy, you may wish to disable this feature. `Kemal` is also able
to do basic directory listing. This feature is disabled by default.

Both of these options are available by passing a hash to `serve_static`.

```ruby
serve_static({"gzip" => true, "dir_listing" => false})
```

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

## Using Layouts

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

### content_for and yield_content

You can capture blocks inside views to be rendered later during the request
with the `content_for` helper. The most common use is to populate different
parts of your layout from your view.

#### Usage

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

## Using Common Paths

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


#### Simple before_get example

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

#### Simple before_all example

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

#### Multiple `before_all`

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

### Browser Redirect

Browser redirects are simple as well. Simply call `env.redirect` in the route's corresponding block.

```ruby
# Redirect browser
get "/logout" do |env|
  # important stuff like clearing session etc.
  env.redirect "/login" # redirect to /login page
end
```

### Custom Public Folder

Kemal mounts `./public` root path of the project as the default public asset folder. You can change this by using `public_folder`.

```ruby
public_folder "path/to/your/folder"
```

### Logging

Kemal enables logging by default.

You can add logging statements to your code:

```ruby
Log.info { "Log message with or without embedded #{variables}" }
```


You can easily disable logging this like so:

```ruby
logging false
```

### Halt

Halt execution with the current context. Returns 200 and an empty response by default.

```ruby
halt env, status_code: 403, response: "Forbidden"
```

*Note:* `halt` can only be used inside routes.

### Custom Errors

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
### Send File

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

## Creating your own middleware

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

### Conditional Middleware Execution
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

### Creating a custom Logger middleware

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

### Kemal Middleware

The Kemal organization has a variety of useful middleware.

- Use [kemal-basic-auth](https://github.com/kemalcr/kemal-basic-auth) to add HTTP Basic Authorization to your Kemal application.
- Use [kemal-session](https://github.com/kemalcr/kemal-session#%EF%B8%8F-csrf-protection) to add CSRF protection to your Kemal application.

# [HTTP Parameters](#http-parameters)

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

# Matches /dir/and/anything/after
get "/dir/*all" do |env|
  all = env.params.url["all"]
  "Found path #{all}"
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

### POST / Form Parameters
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

### Context Storage

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

### Request Properties

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

# [File Upload](#file-upload)

Kemal provides easy access to uploaded files through `env.params.files`. When a file is uploaded via a form, it's automatically stored in a temporary location and accessible through the parameter name.

## Basic File Upload

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

## Advanced File Upload with Validation

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

## File Upload Properties

The uploaded file object has the following properties:

- `filename`: Original filename of the uploaded file
- `tempfile`: Temporary file object containing the uploaded data
- `size`: Size of the uploaded file in bytes
- `headers`: HTTP headers associated with the file upload

## Multiple File Upload

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

## Testing File Upload

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

## Accessing the CSRF token

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

### Accessing Dynamic Url Params

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

# [SSL](#ssl)

Kemal has built-in and easy to use SSL support.

To start your Kemal with SSL support.

```
crystal build --release src/your_app.cr
./your_app --ssl --ssl-key-file your_key_file --ssl-cert-file your_cert_file
```

# [Deployment](#deployment)

### Heroku

You can use [heroku-buildpack-crystal](https://github.com/crystal-lang/heroku-buildpack-crystal) to deploy your Kemal application to Heroku.

### Capistrano

You can use [capistrano-kemal](https://github.com/sdogruyol/capistrano-kemal) to deploy your Kemal application to any server.

### Cross-compilation

You can cross-compile a Kemal app by using this [guide](http://crystal-lang.org/docs/syntax_and_semantics/cross-compilation.html).

# [Environment](#environment)

Kemal respects the `KEMAL_ENV` environment variable and `Kemal.config.env`. It is set to `development` by default.

To change this value to `production`, for example, use:

```
$ export KEMAL_ENV=production
```

If you prefer to do this from within your application, use:

```ruby
Kemal.config.env = "production"
```

When the `KEMAL_ENV` environment variable is not set to `production`, e.g. `development`, an exception page is rendered when an exception is raised which provides a lot of useful information for debugging. However, if the environment variable is set to `production` a standard error page is rendered (see [source](https://github.com/kemalcr/kemal/blob/master/src/kemal/helpers/exception_page.cr#L16)).

*Note:* `KEMAL_ENV` should ***always*** be set to `production` in an production environment for security reasons.

### Improve this guide

Please help us improve this guide with pull requests to [this website repository](https://github.com/kemalcr/kemalcr.com).
