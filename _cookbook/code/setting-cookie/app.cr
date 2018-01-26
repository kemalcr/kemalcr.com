require "kemal"

# Access the context and set cookie.
get "/" do |env|
  my_cookie = HTTP::Cookie.new(
    name: "Example",
    value: "KemalCR",
    http_only: true,
    secure: true
  )
  
  env.response.cookies << my_cookie
end

Kemal.run
