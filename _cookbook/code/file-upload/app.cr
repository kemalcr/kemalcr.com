require "kemal"

post "/upload" do |env|
  file = env.params.files["image1"].tempfile
  file_path = ::File.join [Kemal.config.public_folder, "uploads/", File.basename(file.path)]
  File.open(file_path, "w") do |f|
    IO.copy(file, f)
  end
  "Upload ok"
end

Kemal.run
