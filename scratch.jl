#=
- (can't subtype, use fn) Make JsonResponse as a subtype of HTTP response
- Create logger
- macro w/in macro => HTTP.@register
=#
module Happi

import HTTP
import URIs
import JSON
import Sockets

const APP = HTTP.Router()

const GET = "GET"
const POST = "POST"
const PUT = "PUT"
const DELETE = "DELETE"

const LOCALHOST = Sockets.localhost

const CONTENT_TYPES = Dict{Symbol,String}(
  :text       => "text/plain",
  :html       => "text/html",
  :json       => "application/json",
  :javascript => "application/javascript",
  :form       => "application/x-www-form-urlencoded",
  :multipart  => "multipart/form-data",
  :file       => "application/octet-stream",
  :xml        => "text/xml"
)

function rjson(data::Any ; status::Int = 200, header::Array{Pair{String,String},1} = Pair{String,String}[])
    HTTP.Response(
        status,
        ["Content-Type" => CONTENT_TYPES[:json], header...];
        body = JSON.json(data) * "\n"
    )
end

# Macros for: GET, POST, PUT, DELETE

macro get(path::String, response::Function)
    HTTP.@register(APP,:GET,path,response)
end

macro post(path::String, response::Function)
    HTTP.@register(APP,:POST,path,response)
end

macro put(path::String, response::Function)
    HTTP.@register(APP,:PUT,path,response)
end

macro delete(path::String, response::Function)
    HTTP.@register(APP,:DELETE,path,response)
end


function serve(host=LOCALHOST, port=8081; kw...)
    HTTP.serve(APP,host,port,kw...)
end



export APP,
    GET, POST, PUT, DELETE,
    LOCALHOST,
    CONTENT_TYPES,
    rjson

end # module

############################################

using HTTP
using JSON
using .Happi

@info "Starting module..."

HTTP.@register(APP,GET,"/",r::HTTP.Request -> begin
    rjson(Dict(
        "hello" => "world",
        "dogs" => 3
    ))
end)

HTTP.serve(APP,LOCALHOST,8080)

@info "Done."
