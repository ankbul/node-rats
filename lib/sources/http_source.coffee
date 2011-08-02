http = require 'http'
EventBuffer = require('./../core/event_buffer').EventBuffer


# AB : todo - make this inherit from EventSource. For some reason, the inheritance chain is broken
class HttpSource

  constructor: (@port = 7287) ->

  # responds as quickly as possible
  listen: ->
    console.log "[HTTP] listening on port #{@port}"
    http.createServer( (request, response) ->
      #buffer request.url
      EventBuffer.buffer request.url
      response.writeHead 200, {"Content-Type": "application/json"}
      response.end "[\"OK\",\"#{request.url}\"]"
    ).listen(@port)


exports.HttpSource = HttpSource