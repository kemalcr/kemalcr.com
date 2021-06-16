---
layout: doc
title: Show elapsed time on the web page
---

Monkey-patch `HTTP::Server::Context` adding an attribute called `start_time`.

In each route, even if the route does not explicitely use it, use the `env` variable to hold the context.

```ruby
{% include_relative code/elapsed-time/app.cr %}
```

The layout needs the following to calculate and display the elapsed time in milliseconds:

```ruby
{% include_relative code/elapsed-time/layout.ecr %}
```

[Source Code](https://github.com/kemalcr/kemalcr.com/tree/master/_cookbook/code/elapsed-time)
