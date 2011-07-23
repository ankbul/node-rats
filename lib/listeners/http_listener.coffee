http = require 'http'
EventBuffer = require('./../core/event_buffer').EventBuffer

class HttpListener

  constructor: (@port = 7287) ->

  # responds as quickly as possible
  listen: ->
    console.log "[HTTP] listening on port #{@port}"
    http.createServer( (req, res) ->
      EventBuffer.buffer req
      res.writeHead 200, {"Content-Type": "application/json"}
      res.end '"OK"'
    ).listen(@port)


exports.HttpListener = HttpListener