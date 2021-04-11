
import HTTP
import URIs
import Sockets
import Dates
import JSON2
import MsgPack

module QuickAPI

include("util.jl")

export 
    APP,
    text, json, msgpack,
    @get, @post, @put, @delete,
    serve, serve_async

const APP = HTTP.Router()

const LOCALHOST = Sockets.localhost

const CONTENT_TYPES = Dict{Symbol,String}(
  :text       => "text/plain",
  :json       => "application/json",
  :msgpack    => "application/x-msgpack",
)

#========================================
# Functions for building HTTP responses #
========================================#

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

#=================================
# Macros for handling GET, POST, #
# PUT, DELETE requests           #
=================================#



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


#=============================
# Functions to Serve the App #
=============================#

function serve(host=LOCALHOST, port=8081; kw...)
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

end # module
