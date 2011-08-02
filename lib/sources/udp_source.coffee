dgram = require 'dgram'
EventBuffer = require('./../core/event_buffer').EventBuffer

class UdpSource

  constructor: (@port = 7289) ->

  listen: ->
    console.log "[UDP] listening on port #{@port}"
    server = dgram.createSocket('udp4', (msg, msgInfo) ->
      #console.log "[UDP] Received msg: #{msg}, msgInfo: #{msgInfo}"
      EventBuffer.buffer msg.toString()
    )
    server.bind @port

  # method to send a datagram to itself
  loopback: (msg) ->
    datagram = new Buffer(msg)
    client = dgram.createSocket('udp4')
    client.send(datagram, 0, datagram.length, @port, 'localhost')
    client.close()


exports.UdpSource = UdpSource