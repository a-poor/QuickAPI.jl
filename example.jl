
using Pkg
Pkg.activate(".")

using HTTP

##########################

init() = HTTP.Router()

function route(resp_fn::Function, app::HTTP.Router, route::String, method::Union{String,Symbol} = :GET)
    HTTP.@register(app,method,route,resp_fn)
end

function run(app::HTTP.Router, host = "127.0.0.1", port = 8081)
    @info "Serving at http://$host:$port ..."
    HTTP.serve(app,host,port)
end

##########################

const APP = init()

function f(r::HTTP.Request)
    return HTTP.Response(200,"{\"Hello\":\"World!\"}")
end

route(f,APP,"/",:GET)

run(APP)

