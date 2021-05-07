
module fns

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
