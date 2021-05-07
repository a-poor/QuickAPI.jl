
using HTTP, Sockets

const APP = HTTP.Router()

function request_handler(req::HTTP.Request)
    println("$(req.method) request to $(req.target)")
    return "Hello, world!"
end

HTTP.@register APP "GET" "/" request_handler

function stream_handler(http::HTTP.Stream)
    host, port = Sockets.getpeername(http)
    println("Request from $host:$port")
    return HTTP.handle(APP, http) # regular handling
end

# HTTP.serve with stream=true
HTTP.serve(stream_handler, Sockets.localhost, 8081; stream=true) # <-- Note stream=true

# or HTTP.listen
HTTP.listen(stream_handler, Sockets.localhost, 8081)


