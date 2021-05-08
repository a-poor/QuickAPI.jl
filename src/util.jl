# util.jl
# Utility code for QuickAPI.jl


"""
@trycatch expr

Convenience macro which wraps an expression in a `try/catch` block.
If the expression throws an error, it will be printed with the 
`@error` macro.
# Examples
julia> @trycatch 1 + 1
2
julia> @trycatch 1 + "dog"
┌ Error: MethodError(+, (1, "dog"), 0x0000000000006cbc)
└ @ Main REPL[13]:6
"""
macro trycatch(expr)
    quote
        try
            $expr
        catch err
            @error err
        end
    end
end


function iscallable(s::Symbol)
    Bool(length(methods(eval(s))))
end


macro whatisit(e)
    if typeof(e) == Symbol
        if iscallable(e)
            println("$e looks like an already-defined function to me!")
            return
        else
            println("$e isn't a function!")
        end
    else if typeof(e) == Expr
        if 
    else
        println("$e isn't a Symbol or an Expr! It appears to be a $(typeof($e))")

    end
end


macro getargmap(e::Expr)
    @assert e.head == :->
    args = [a.args for a in e.args[1].args]
    argmap = Dict([(a => eval(b)) for (a,b) in args])
    quote 
        $([ "$k::String" for k in keys(argmap) ])
    end
end


macro fillintheblanks(args::Dict{String,Any},fn::Function)
    fmt_args = join(["$a=$v" for (a,v) = $args]
    quote quote
        $fn($(join(
            "$a=$v" for (a,v) = $args
        )))
    end end
end

function fn(a::Int = 1, b::String = "2")
    @show (a, b)
end

args = Dict("a"=>1,"b"=>"test")

@fillintheblanks args fn

macro passiton(fn,args)
    quote
        fn($args...)
    end
end

