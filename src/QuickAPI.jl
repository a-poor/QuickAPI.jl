
import HTTP
import URIs
import Sockets
import Dates
import JSON2
import MsgPack

module QuickAPI

include("util.jl")
include("errors.jl")

export 
    APP,
    text, json, msgpack,
    @route, @get, @post, @put, @delete,
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

macro route(method::Symbol,path::String,response)
    HTTP.@register(
        APP,
        method,
        path,
        response
    )
end

macro get(path::String, response)
    quote
        @route(
            :GET,
            $path,
            $response
        )
    end
end

macro post(path::String, response)
    quote
        @route(
            :POST,
            $path,
            $response
        )
    end
end

macro put(path::String, response)
    quote
        @route(
            :PUT,
            $path,
            $response
        )
    end
end

macro delete(path::String, response)
    quote
        @route(
            :DELETE,
            $path,
            $response
        )
    end
end


#=============================
# Functions to Serve the App #
=============================#

function serve(host=LOCALHOST, port=8081; kw...)
    @trycatch HTTP.serve(
        APP,
        host,
        port;
        kw...
    )
end

function serve_async(host=LOCALHOST, port=8081; kw...)
    @async HTTP.serve(APP,host,port,kw...)
end


end # module
