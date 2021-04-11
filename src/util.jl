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
