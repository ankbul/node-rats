TcpSource = require('./tcp_source').TcpSource
HttpSource = require('./http_source').HttpSource

class EventSource
  @listen: ->
    new TcpSource().listen()
    new HttpSource().listen()

exports.EventSource = EventSource