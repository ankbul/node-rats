socket = require 'socket.io'
RedisSink = require('../sinks/redis_sink').RedisSink
View = require('../models/view').View
TimeSlice = require('../models/time_slice').TimeSlice
SocketClient = require('./socket_client').SocketClient

class SocketManager

  @COMMANDS = {
    CHANGE_VIEW : 'change_view',
    EVENTS      : 'events'
  }

  constructor: (@port = 3030, @frequency = 2500) ->
    @clients = []

  listen: ->
    console.log "[SOCKET.IO] listening on port #{@port}"
    @io = socket.listen(@port)
    @io.sockets.on 'connection', (socket) =>
      client = new SocketClient(socket)
      @clients.push(client)

      socket.on SocketManager.COMMANDS.CHANGE_VIEW, (data) =>
        console.log ('changing the view modafucker')
        console.log(data)
        client.changeView(data.path, data.type, data.timeSlice)

      socket.emit 'connection'

    setInterval () =>
      @broadcastClients()
    , @frequency

  broadcastClients: ->
    console.log('trying to broadcast')

    @clients.forEach( (client, index) ->
      switch client.viewType
        when View.VIEW_LIVE
          RedisSink.getRollingLiveEventData(client.currentView, (eventView) =>
            client.socket.emit SocketManager.COMMANDS.EVENTS, eventView
          )
        when View.VIEW_HISTORICAL
          RedisSink.getHistoricalEventData(client.currentView, (eventView) ->
            client.socket.emit SocketManager.COMMANDS.EVENTS, eventView
          )
        else
          console.error('No View Information')
    )

#      if client.
#      historicalView = new View({timeSlice: TimeSlice.ONE_MINUTE, path:'popchat/login', type: 'historical', measurements: 40})

#      RedisSink.getHistoricalEventData(client.currentView, (eventView) ->
#        console.log client.currentView
#        console.log '[Server.coffee]', eventView
#        client.socket.emit 'events', eventView
#      )
#      RedisSink.getLiveEventData(client.currentView, (eventView) =>
#        client.socket.emit 'events', data
#      )



exports.SocketManager = SocketManager

#data = {
#  view : {
#    path : '',
#    type : 'historical',
#    timeSlice : '1m'
#  },
#  events : [{
#    name: 'wallpost',
#    count: 1100+50,
#    path : 'wallpost',
#    redisPath : 'rats://wallpost',
#    measurements: [ [0, 50], [1, 30], [2, 80] ]
#  },
#  {
#    name: 'tf',
#    count : 800 + 40,
#    path : 'wallpost/tf'
#    redisPath : 'rats://wallpost/tf'
#    measurements : [ [0, 10], [1, 30], [2, 8] ]
#  },
#  {
#    name: 'clicked',
#    count : 500 ,
#    path : 'wallpost/tf/clicked'
#    redisPath : 'rats://wallpost/tf/clicked'
#    measurements: [ [0, 75], [1, 15], [2, 80] ]
#  }]
#}


#      data.events[0].events[0].events[0].count += Math.floor(Math.random() * 320)
#      data.events[0].events[0].events[1].count += Math.floor(Math.random() * 320)
#      data.events[0].events[0].events[2].count += Math.floor(Math.random() * 320)
#      data.events[0].events[1].events[0].count += Math.floor(Math.random() * 120)
#      data.events[0].events[1].events[1].count += Math.floor(Math.random() * 120)
#      data.events[0].events[0].count = data.events[0].events[0].events[0].count + data.events[0].events[0].events[1].count + data.events[0].events[0].events[2].count
#      data.events[0].events[1].count = data.events[0].events[1].events[0].count + data.events[0].events[1].events[1].count
#      data.events[0].count = data.events[0].events[0].count + data.events[0].events[1].count



