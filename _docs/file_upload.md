---
layout: doc
title: "File Upload"
order: 7
---

File uploads can be accessed from request `params` like `env.params.files["filename"]`.

It has the following methods

- `tmpfile`: This is temporary file for file upload. Useful for saving the upload file.
- `filename`: File name of the file upload. (logo.png, images.zip e.g)
- `headers`: Headers for the file upload.
- `creation_time`: Creation time of the file upload.
- `modification_time`: Last Modification time of the file upload.
- `read_time`: Read time of the file upload.
- `size`: Size of the file upload.

Here's a fully working sample for reading an image file upload with key `image1` and saving it under `public/uploads`.

```ruby
post "/upload" do |env|
  file = env.params.files["image1"]
  filename = file.filename
  # Be sure to check if file.filename is not empty otherwise it'll raise a compile time error
  if !filename.is_a?(String)
    p "No filename included in upload"
  else
    file_path = ::File.join [Kemal.config.public_folder, "uploads/", filename]
    File.open(file_path, "w") do |f|
      IO.copy(file.tmpfile, f)
    end
    "Upload ok"
  end
end
```

You can test this with below `curl` command.

`curl -F "image1=@/Users/serdar/Downloads/kemal.png" http://localhost:3000/upload`