---
layout: doc
title: "File Upload"
order: 7
---

Kemal has built-in and easy to use file upload handling. Here's a sample for multiple file upload.

```ruby
require "kemal"

post "/upload" do |env|
  parse_multipart(env) do |f|
    image1 = f.data if f.field == "image1"
    image2 = f.data if f.field == "image2"
    puts f.meta
    puts f.headers
    "Upload complete"
  end
end

Kemal.run
```

`curl` command for testing.

`curl -F "image=@image1.png" -F "image2=@image2.png"  http://localhost:3000/upload`