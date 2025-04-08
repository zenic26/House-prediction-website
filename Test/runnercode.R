> pr <- plumber::plumb("api.R")
Error in plumber::plumb("api.R") : File does not exist: api.R
> plumb(file='D:/Housing_prediction/Test/api.R')$run()
Running plumber API at http://127.0.0.1:11126
Running swagger Docs at http://127.0.0.1:11126/__docs__/
  Error reporting has been turned off by default. See `pr_set_debug()` for more details.
To disable this message, set a debug value.
This message is displayed once per session.

> # Load plumber
  > library(plumber)
> 
  > # Register CORS hook and run the API
  > pr <- plumber::plumb("D:/Housing_prediction/Test/api.R")
> pr$registerHooks(list(preroute = cors))
Error: object 'cors' not found
> cors <- function(req, res) {
  +     res$setHeader("Access-Control-Allow-Origin", "*")
  +     res$setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
  +     res$setHeader("Access-Control-Allow-Headers", "Content-Type")
  +     plumber::forward()
  + }
> 
  > cors <- function(req, res) {
    +     res$setHeader("Access-Control-Allow-Origin", "*")
    +     res$setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
    +     res$setHeader("Access-Control-Allow-Headers", "Content-Type")
    +     plumber::forward()
    + }
> 
  > library(plumber)
> 
  > # Load your API script
  > pr <- plumber::plumb("D:/Housing_prediction/Test/api.R")
> 
  > # Register CORS hook
  > pr$registerHooks(list(preroute = cors))
> 
  > # Run the API
  > pr$run(port = 11126)