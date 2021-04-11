# TODO

* [ ] Create Logger Handler
    * [ ] Find out how to get `client IP` and `http request` in same handler
* [ ] Create Handler that will convert `path variables` and `query parameters` into function arguments
    * [ ] Find out how to get function `arg/kwarg` types from a function (so that the default string values can be parsed)
* [ ] Possibly create handler to automatically convert function returns to response types (ie instead of returning `json([1,2])` the user can set the default response handler to `json` and then just return `[1,2]`)
* [ ] Write code to stack handler (would this be better suited for `Mux` or can it be done in `HTTP`)
