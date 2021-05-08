
module fns


abstract type FunctionArgument end

struct Arg <: FunctionArgument end
struct KwArg <: FunctionArgument end
struct OptionalArg <: FunctionArgument end


# Code to parse argument Expr into 
# `FunctionArgument`s
# ...



#= 
Function for Extracting Parameters
Accepts lambda functions only. In the form:
```
@get_args (a,b) -> a + b
```
or 
```
@get_args function(a,b)
    a + b
end
```

(TODO) Not yet:
```
@get_args add(a,b) = a + b
```
(TODO) or:
```
function add(a,b)
    a + b
end

@get_args add
```
=#
function get_args(fn::Expr)
  # Check that this function was defined inline
  @assert fn.head in (:->, :function), "Function should be defined inline."
  arg_exprs = fn.args[1].args
  # ...
end


function is_arg(e::Expr)

end

function is_optional(e::Expr)

end

function is_kwargs(e::Expr)

end

function is_kwarg(e::Expr)

end



end # module





# a = Argument
# o = Optional Argument
# k1 = Keyword Argument
# k2 = Keyword Argument
fn = :((a::Int, o::Float64 = 1. ; k1::Int = 1, k2::Float64 = 2.) -> 42)

all_args = fn.args[1].args
#=
3-element Vector{Any}:
 :($(Expr(:parameters, :($(Expr(:kw, :(k1::Int), 1))), :($(Expr(:kw, :(k2::Float64), 2.0))))))
 :(a::Int)
 :(o::Float64 = 1.0)
=#

arg = all_args[2] # :(a::Int)

opt_arg = all_args



kwargs = all_args[1]



#=

Recursively deconstruct function argument `Expr`.

* Args are the simplest :(argname::ArgType)
* Optional Args have head `:(=)` and args `[:(name::Type),"Default Value"]`
* All Kwargs are grouped together into a single expression with head `:parameters`
* Individual kwargs have head `:kw` and args `[:(kwarg_name::Type),"Default Value"]`
=#















