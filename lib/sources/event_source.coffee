TcpSource = require('./tcp_source').TcpSource
HttpSource = require('./http_source').HttpSource
EventBuffer = require('./../core/event_buffer').EventBuffer

class EventSource

  @listen: ->
    new TcpSource().listen()
    new HttpSource().listen()

  #buffer: (data) ->
  #  EventBuffer.buffer data

exports.EventSource = EventSource