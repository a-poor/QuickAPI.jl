#=
- (can't subtype, use fn) Make JsonResponse as a subtype of HTTP response
- Create logger
- macro w/in macro => HTTP.@register (working for now)
- Handle route path variables
- 
=#
module QuickAPI

import HTTP
import URIs
import Sockets
import JSON3
import MsgPack
import Dates

const APP = HTTP.Router()

const GET    = :GET
const POST   = :POST
const PUT    = :PUT
const DELETE = :DELETE

const LOCALHOST = Sockets.localhost

const CONTENT_TYPES = Dict{Symbol,String}(
  :text       => "text/plain",
  :json       => "application/json",
  :msgpack    => "application/x-msgpack",
)


# Functions for Response Types

function text(data::Any ; status::Int = 200, header::Array{Pair{String,String},1} = Pair{String,String}[])
    HTTP.Response(
        status,
        ["Content-Type" => CONTENT_TYPES[:text], header...];
        body = string(data) * "\n"
    )
end

function json(data::Any ; status::Int = 200, header::Array{Pair{String,String},1} = Pair{String,String}[])
    HTTP.Response(
        status,
        ["Content-Type" => CONTENT_TYPES[:json], header...];
        body = JSON2.write(data) * "\n"
    )
end

function msgpack(data::Any ; status::Int = 200, header::Array{Pair{String,String},1} = Pair{String,String}[])
    HTTP.Response(
        status,
        ["Content-Type" => CONTENT_TYPES[:msgpack], header...];
        body = MsgPack.pack(data)
    )
end

# Macros for handling GET, POST, 
# PUT, DELETE requests

macro get(path::String, response)
    HTTP.@register(
        APP,
        :GET,
        path,
        response
    )
end

macro post(path::String, response)
    HTTP.@register(
        APP,
        :POST,
        path,
        response
    )
end

macro put(path::String, response)
    HTTP.@register(
        APP,
        :PUT,
        path,
        response
    )
end

macro delete(path::String, response)
    HTTP.@register(
        APP,
        :DELETE,
        path,
        response
    )
end

# Logger function
function log_request()

end

# Functions to Serve the App

function serve(host=LOCALHOST, port=8081; kw...)
    @info "Serving at http://$host:$port/"
    try
        HTTP.serve(
            APP,
            host,
            port;
            kw...
        )
    catch e
        @error e
    end
end

function serve_async(host=LOCALHOST, port=8081; kw...)
    @async HTTP.serve(APP,host,port,kw...)
end

export 
    APP,
    LOCALHOST,
    text, json, msgpack,
    @get, @post, @put, @delete,
    serve, serve_async

end # module

############################################

# using HTTP
# using JSON
using .QuickAPI
using Sockets

@info "Starting module..."

@get "/" (r::HTTP.Request -> begin
    json(Dict(
        "hello" => "world",
        "dogs" => 3
    ))
end)

serve(
    LOCALHOST, 
    8081,
    tcpisvalid = sock::Sockets.TCPSocket -> begin
        @show sock
        @show sock.buffer
        true
    end,
)

@info "Done."
