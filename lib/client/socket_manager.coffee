socket        = require 'socket.io'
RedisSink     = require('../sinks/redis_sink').RedisSink
View          = require('../models/view').View
Commands      = require('../models/commands').Commands
TimeSlice     = require('../models/time_slice').TimeSlice
SocketClient  = require('./socket_client').SocketClient

class SocketManager
  constructor: (@port = 3030, @frequency = 250) ->
    @clients = []

  listen: ->
    console.log "[SOCKET.IO] listening on port #{@port}"
    @io = socket.listen(@port)
    @io.sockets.on Commands.CONNECTED, (socket) =>
      client = new SocketClient(socket)
      @clients.push(client)

      socket.on Commands.CHANGE_VIEW, (data) =>
        client.changeView(data.path, data.type, data.timeSlice)

      socket.emit Commands.CONNECTED

    setInterval () =>
      @broadcastClients()
    , @frequency

  broadcastClients: ->
    @clients.forEach( (client, index) ->
      switch client.viewType
        when View.VIEW_LIVE
          RedisSink.getRollingLiveEventData(client.currentView, (eventView) =>
            client.socket.emit Commands.EVENTS, eventView
          )
        when View.VIEW_HISTORICAL
          RedisSink.getHistoricalEventData(client.currentView, (eventView) ->
            client.socket.emit Commands.EVENTS, eventView
          )
        else
          console.error('No View Information')
    )

exports.SocketManager = SocketManager