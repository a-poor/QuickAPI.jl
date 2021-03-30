
using Pkg
Pkg.activate()

using HTTP
import HTTP.@register
import HTTP.serve
# using Happi


const APP = HTTP.Router()
@register(APP,:GET,"/",r::HTTP.Request -> begin
    @show r
    return HTTP.Response(200,"Hello, World!")
end)

serve(APP,"127.0.0.1",8080)
