require "kemal"

# Handle multiple file uploads via POST request to /upload endpoint
post "/upload" do |env|
  uploaded_file_names = [] of String
  
  # Get all files from the images[] field
  if env.params.files.has_key?("images[]")
    # env.params.files["images[]"] returns an array of uploaded files
    env.params.all_files["images[]"].each do |uploaded_file|
      
      # Validate each file
      max_size = 5 * 1024 * 1024
      
      if uploaded_file.size.not_nil! > max_size
        next # Skip all_files that are too large
      end
      
      # Validate file type
      allowed_extensions = [".jpg", ".jpeg", ".png", ".gif"]
      file_extension = File.extname(uploaded_file.filename || "").downcase

      unless allowed_extensions.includes?(file_extension)
        next # Skip invalid file types
      end
      
      # Generate unique filename
      unique_filename = "#{Time.utc.to_unix}_#{Random.rand(1000)}_#{uploaded_file.filename}"
      file_path = ::File.join [Kemal.config.public_folder, "uploads/", unique_filename]
      
      # Save the file
      File.open(file_path, "w") do |f|
        IO.copy(uploaded_file.tempfile, f)
      end
      
      uploaded_file_names << unique_filename
    end
  end
  
  if uploaded_file_names.empty?
    "No valid files were uploaded"
  else
    "Successfully uploaded #{uploaded_file_names.size} files: #{uploaded_file_names.join(", ")}"
  end
end

# Start the Kemal server
Kemal.run