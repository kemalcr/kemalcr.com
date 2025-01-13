require "kemal"
require "db"
require "mysql"

# Initialize a single DB connection
DB_URL = "mysql://root:password@localhost:3306/mydb"
DB = DB.open(DB_URL)

# Example User model
class User
  property id : Int32
  property name : String
  property email : String

  def initialize(@id, @name, @email)
  end
end

# List all users
get "/users" do |env|
  # Initialize empty array to store User objects
  users = [] of User
  
  # Query database for all users
  DB.query "SELECT * FROM users" do |rs|
    # For each row in result set
    rs.each do
      # Create new User object from row data and add to array
      users << User.new(
        id: rs.read(Int32),    # Read id column as Integer
        name: rs.read(String), # Read name column as String 
        email: rs.read(String) # Read email column as String
      )
    end
  end

  # Return users array as JSON response
  users.to_json
end

# Create a new user
post "/users" do |env|
  name = env.params.json["name"].as(String)
  email = env.params.json["email"].as(String)
  
  user_id = DB.exec "INSERT INTO users (name, email) VALUES (?, ?) RETURNING id", name, email do |rs|
    rs.each { return rs.read(Int32) }
  end
  
  {message: "User created with id: #{user_id}"}.to_json
end

# Delete a user
delete "/users/:id" do |env|
  id = env.params.url["id"].to_i

  # Delete user and check if any rows were affected
  result = DB.exec "DELETE FROM users WHERE id = ?", id
  
  if result.rows_affected > 0
    {message: "User deleted successfully"}.to_json
  else
    env.response.status_code = 404
    {message: "User not found"}.to_json
  end
end

Kemal.run
