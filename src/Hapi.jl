
module Hppi

using HTTP

init() = HTTP.Router()

function route(resp_fn::Function, app::HTTP.Router, route::String, method = :GET)
    HTTP.@register(app,method,route,resp_fn)
end

function run(app::HTTP.Router, host = "127.0.0.1", port = 8081)
    HTTP.serve(app,host,port)
end

export init, route, run

end # module
