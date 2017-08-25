require "kemal"

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

Kemal.run
