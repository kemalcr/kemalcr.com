require "kemal"

# Handle file uploads via POST request to /upload endpoint
post "/upload" do |env|
  uploaded_file = env.params.files["image"]
  
  # Validate file size (e.g., max 5MB)
  max_size = 5 * 1024 * 1024
  if uploaded_file.size > max_size
    halt env, status_code: 400, response: "File too large"
  end
  
  # Validate file type by extension
  allowed_extensions = [".jpg", ".jpeg", ".png", ".gif"]
  file_extension = File.extname(uploaded_file.filename || "").downcase
  
  unless allowed_extensions.includes?(file_extension)
    halt env, status_code: 400, response: "Invalid file type"
  end
  
  # Generate a unique filename to prevent conflicts
  unique_filename = "#{Time.utc.to_unix}_#{uploaded_file.filename}"
  file_path = ::File.join [Kemal.config.public_folder, "uploads/", unique_filename]
  
  # Save the file
  File.open(file_path, "w") do |f|
    IO.copy(uploaded_file.tempfile, f)
  end
  
  "File uploaded successfully as: #{unique_filename}"
end

# Start the Kemal server
Kemal.run
