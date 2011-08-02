net = require 'net'
EventBuffer = require('./../core/event_buffer').EventBuffer


class TcpSource
  constructor: (@port = 7288) ->

  # responds as quickly as possible
  listen: ->
    server = net.createServer( (socket) ->
      socket.write('hello\n')
      socket.pipe(socket)

      socket.on('data')
    )

    server.on('error', (e) ->
      if e.code == 'EADDRINUSE'
        console.log "Address #{@port} in use"
    )



    console.log "[TCP] listening on port #{@port}"
    server.listen(@port, 'localhost')


exports.TcpSource = TcpSource