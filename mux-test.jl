
using Mux


function r(d)
  @show d
  respond("Hello, world")
end

@app test = (
  Mux.defaults,
  page("/",r)
)

serve(test)
