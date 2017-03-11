---
layout: doc
title: Middlewares
order: 9
---

Middlewares a.k.a `Handler`s are the building blocks of `Kemal`. It lets you seperate your concerns into different layers.

Each middleware is supposed to have one responsibility. Take a look at `Kemal`'s built-in middlewares to see what that means.

## Creating your own middleware

You can create your own middleware by inheriting from ```Kemal::Handler```

```ruby
class CustomHandler < Kemal::Handler
  def call(context)
    puts "Doing some custom stuff here"
    call_next context
  end
end

add_handler CustomHandler.new
```

### Custom middleware filters
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

## Creating a custom Logger middleware

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
...
```

That's it!

### Kemal Middlewares

Kemal organization contains some useful middlewares

- [kemal-basic-auth](https://github.com/kemalcr/kemal-basic-auth): Add HTTP Basic Authorization to your Kemal application.
- [kemal-csrf](https://github.com/kemalcr/kemal-csrf): Add CSRF protection to your Kemal application.

