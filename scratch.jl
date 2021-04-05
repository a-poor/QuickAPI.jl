#=
- (can't subtype, use fn) Make JsonResponse as a subtype of HTTP response
- Create logger
- macro w/in macro => HTTP.@register (working for now)
- Handle route path variables
=#
module Hapi

import HTTP
import URIs
import JSON2
import MsgPack
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
  :xml        => "text/xml",
  :msgpack    => "application/x-msgpack"
)

function rjson(data::Any ; status::Int = 200, header::Array{Pair{String,String},1} = Pair{String,String}[])
    HTTP.Response(
        status,
        ["Content-Type" => CONTENT_TYPES[:json], header...];
        body = JSON.json(data) * "\n"
    )
end

# Responses

function TextResponse(data::Any; status::Int=200, headers=Pair{String,String}[], kw...)
    HTTP.Response(
        status,
        ["Content-Type"=>CONTENT_TYPES[:text],
        headers...] ;
        body=string(data),
        kw...
    )
end

function JsonResponse(data::Any; status::Int=200, headers=Pair{String,String}[], kw...)
    HTTP.Response(
        status,
        ["Content-Type"=>CONTENT_TYPES[:json],
        headers...] ;
        body=JSON2.write(data),
        kw...
    )
end

function MsgpackResponse(data::Any; status::Int=200, headers=Pair{String,String}[], kw...)
    HTTP.Response(
        status,
        ["Content-Type"=>CONTENT_TYPES[:msgpack],
        headers...] ;
        body=MsgPack.pack(data),
        kw...
    )
end

const RESPONSE_TYPES = Dict(
    :text    => TextResponse,
    :json    => JsonResponse,
    :msgpack => MsgpackResponse
)

# Macros for: GET, POST, PUT, DELETE

macro route(path::String, method::Symbol, response_type::Symbol, response)
    HTTP.@register(
        APP,
        method,
        path,
        r -> JsonResponse(response(r))
    )
end

macro get(path::String, response)
    HTTP.@register(
        APP,
        :GET,
        path,
        r -> JsonResponse(response(r))
    )
end

macro post(path::String, response)
    HTTP.@register(
        APP,
        :POST,
        path,
        r -> JsonResponse(response(r))
    )
end

macro put(path::String, response)
    HTTP.@register(
        APP,
        :PUT,
        path,
        r -> JsonResponse(response(r))
    )
end

macro delete(path::String, response)
    HTTP.@register(
        APP,
        :DELETE,
        path,
        r -> JsonResponse(response(r))
    )
end

# Serve the app

function serve(host=LOCALHOST, port=8081; kw...)
    HTTP.serve(APP,host,port,kw...)
end



export APP,
    GET, POST, PUT, DELETE,
    LOCALHOST,
    CONTENT_TYPES,
    # rjson,
    @get, @post, @put, @delete,
    serve

end # module

############################################

# using HTTP
# using JSON
using .Hapi

@info "Starting module..."

@get "/" (r::HTTP.Request -> begin
    Dict(
        "hello" => "world",
        "dogs" => 3
    )
end)

serve(LOCALHOST, 8080)

@info "Done."
