---
layout: doc
title: MySQL DB Recipe
---

Add the `mysql` shard to your `shard.yml` file.

```yaml
dependencies:
  mysql:
    github: crystal-lang/crystal-mysql
```

```ruby
{% include_relative code/mysql-db/app.cr %}
```

[Source Code](https://github.com/kemalcr/kemalcr.com/tree/master/_cookbook/code/mysql-db)