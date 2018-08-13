---
layout: doc
title: Using Reuse Port for Multiple Kemal Processes
---

```ruby
{% include_relative code/reuse-port/app.cr %}
```

You can use the following script to spawn multiple Kemal processes according to your CPU cores.

```sh
#!/bin/bash

for i in $(seq 1 $(nproc --all)); do
  ./app
done

wait
```

***Important***: This is for demonstration purpose only. You should use a mature process manager / monitor for production.

[Source Code](https://github.com/kemalcr/kemalcr.com/tree/master/_cookbook/code/reuse-port)
