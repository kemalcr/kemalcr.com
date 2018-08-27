require "kemal"

post "/upload" do |env|
  env.params.files.each do |name, file|
    filename = file.filename

    if !filename.is_a?(String)
      "No filename included in upload"
    else
      file_path = ::File.join [Kemal.config.public_folder, "uploads/", filename]
      File.open(file_path, "w") do |f|
        IO.copy(file.tmpfile, f)
      end
      "Upload OK"
    end
  end
end

Kemal.run
