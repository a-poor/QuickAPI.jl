
using HTTP

module Happi

function init()
    HTTP.Router()
end

function route(resp_fn::Function, app::HTTP.Router, route = "/", method = :GET)

end

function run(app::HTTP.Router, host = "127.0.0.1", port = 8081)

end

export init, route, run

end # module
