class HTTP::Server::Context
  getter start_time : Time::Span = Time.monotonic
end

get "/" do |env|
  render "src/views/main.ecr", "src/views/layouts/layout.ecr"
end
