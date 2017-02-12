---
layout: doc
title: "File Upload"
order: 7
---

File uploads can be accessed from request `params` like `env.params.files["filename"]`.

It has 5 useful methods to get the job done!

- `tmpfile`: This is the temporary file for file upload. Useful for saving or manipulating the upload file.
- `tmpfile_path`: File path of `tmpfile`.
- `filename`: File name of the file upload. (`logo.png`, `images.zip` e.g)
- `meta`: Meta information for the file upload.
- `headers`: Request headers for the file upload.

Here's a fully working sample for reading an image file upload with key `image1` and saving it under `public/uploads`.

```ruby
post "/upload" do |env|
  file = env.params.files["image1"].tmpfile
  file_path = ::File.join [Kemal.config.public_folder, "uploads/", file.filename]
  File.open(file_path, "w") do |f|
    IO.copy(file, f)
  end
  "Upload ok"
end
```

You can test this with below `curl` command.

`curl -F "image1=@/Users/serdar/Downloads/kemal.png" http://localhost:3000/upload`