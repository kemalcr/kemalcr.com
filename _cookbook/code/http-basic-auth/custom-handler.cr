require "kemal-basic-auth"

class CustomAuthHandler < Kemal::BasicAuth::Handler
  only ["/dashboard", "/admin"] # routes with basic authorization

  def call(context)
    return call_next(context) unless only_match?(context)
    super
  end
end

Kemal.config.auth_handler = CustomAuthHandler