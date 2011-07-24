http = require 'http'
EventBuffer = require('./../core/event_buffer').EventBuffer

class HttpSource

  constructor: (@port = 7287) ->

  # responds as quickly as possible
  listen: ->
    console.log "[HTTP] listening on port #{@port}"
    http.createServer( (request, response) ->
      EventBuffer.buffer request.url
      response.writeHead 200, {"Content-Type": "application/json"}
      response.end '"OK"'
    ).listen(@port)


exports.HttpSource = HttpSource