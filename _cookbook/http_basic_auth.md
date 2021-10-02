---
layout: doc
title: HTTP Basic Auth Recipe
---

```ruby
{% include_relative code/http-basic-auth/app.cr %}
```

This will add basic authorization to all routes in your application. However, some applications only need authorization on some of its routes. This is something can be easily done by creating a custom authorization handler.

```ruby
{% include_relative code/http-basic-auth/custom-handler.cr %}
```

[Source Code](https://github.com/kemalcr/kemalcr.com/tree/master/_cookbook/code/http-basic-auth)