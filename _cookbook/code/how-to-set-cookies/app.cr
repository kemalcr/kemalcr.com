require "kemal"

# You can easily access the context and set cookie.
get "/" do |env|
  env.response.cookies << HTTP::Cookie.new(name: "Example", value: "KemalCR", 
                                           http_only: true, secure: true)
end

Kemal.run
