require "kemal"
require "kemal-session"

# Session configuration
Kemal::Session.config do |config|
  config.cookie_name = "kemal_sessid"
  config.secret = "my-secret-key-change-this-in-production"
  config.gc_interval = 2.minutes
end

# Home page - display session information
get "/" do |env|
  session = env.session
  visit_count = session.int?("visit_count") || 0
  visit_count += 1
  session.int("visit_count", visit_count)

  username = session.string?("username")

  html = <<-HTML
  <h1>Kemal Session Example</h1>
  <p>Your visit count: #{visit_count}</p>
  #{username ? "<p>Welcome, #{username}!</p>" : "<p>You are not logged in.</p>"}
  
  <hr>
  <h3>Actions:</h3>
  <a href="/login">Login</a> | 
  <a href="/logout">Logout</a> | 
  <a href="/profile">Profile</a>
  HTML

  html
end

# Login page
get "/login" do
  <<-HTML
  <h2>Login</h2>
  <form method="post" action="/login">
    <input type="text" name="username" placeholder="Username" required>
    <input type="password" name="password" placeholder="Password" required>
    <button type="submit">Login</button>
  </form>
  <a href="/">Home</a>
  HTML
end

# Login process
post "/login" do |env|
  username = env.params.body["username"].as(String)
  password = env.params.body["password"].as(String)

  # Simple authentication (use database in real applications)
  if username == "admin" && password == "123456"
    env.session.string("username", username)
    env.session.string("role", "admin")
    env.redirect "/"
  else
    "Invalid username or password! <a href='/login'>Try again</a>"
  end
end

# Logout process
get "/logout" do |env|
  env.session.destroy
  env.redirect "/"
end

# Profile page (login required)
get "/profile" do |env|
  username = env.session.string?("username")

  if username
    role = env.session.string?("role") || "user"
    <<-HTML
    <h2>Profile Page</h2>
    <p>User: #{username}</p>
    <p>Role: #{role}</p>
    <p>Session ID: #{env.session.id}</p>
    <a href="/">Home</a>
    HTML
  else
    env.redirect "/login"
  end
end

# Display session information as JSON
get "/session/info" do |env|
  env.response.content_type = "application/json"
  {
    session_id:  env.session.id,
    visit_count: env.session.int?("visit_count"),
    username:    env.session.string?("username"),
  }.to_json
end

Kemal.run
