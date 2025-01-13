---
layout: doc
title: PostgreSQL DB Recipe
---

Add the `pg` shard to your `shard.yml` file.

```yaml
dependencies:
  pg:
    github: will/crystal-pg
```

```ruby
{% include_relative code/postgresql-db/app.cr %}
```

[Source Code](https://github.com/kemalcr/kemalcr.com/tree/master/_cookbook/code/postgresql-db)