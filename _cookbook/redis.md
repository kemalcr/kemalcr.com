---
layout: doc
title: Redis Recipe
---

Add the `redis` shard to your `shard.yml` file.

```yaml
dependencies:
  redis:
    github: crystal-lang/crystal-redis
```

```ruby
{% include_relative code/redis/app.cr %}
```

[Source Code](https://github.com/kemalcr/kemalcr.com/tree/master/_cookbook/code/redis)