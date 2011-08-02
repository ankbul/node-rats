#TcpSource = require('./tcp_source').TcpSource
UdpSource = require('./udp_source').UdpSource
HttpSource = require('./http_source').HttpSource

class EventSource

  @listen: ->
    #new TcpSource().listen()
    new UdpSource().listen()
    new HttpSource().listen()


exports.EventSource = EventSource