require './lib/core/extensions'
express = require 'express'
socket = require 'socket.io'
config = require('./config').config
SocketManager = require('./lib/client/socket_manager').SocketManager
EventSource = require('./lib/sources/event_source').EventSource
TimeSlice = require('./lib/models/time_slice').TimeSlice
Event = require('./lib/models/event').Event
View = require('./lib/models/view').View


EventSource.listen()


# set up client
app = express.createServer();
app.use express.static __dirname + '/public'
app.listen(config.express.port)


# set up websocket input
socketManager = new SocketManager config.socket.port
socketManager.listen()


Event = require('./lib/models/event').Event


# testing
if true

  RedisSink = require('./lib/sinks/redis_sink').RedisSink

  if true
    #RedisSink.getLiveEventData(new View({timeSlice: TimeSlice.ONE_DAY, path:'popchat'}), (eventView) ->
    #  console.log '[Server.coffee]', eventView, '!!!!!!!!!!!!!!!!', eventView.eventTree.events
    #  eventView.eventTree.print()
    #)
    RedisSink.getLiveEventData(new View({timeSlice: TimeSlice.ONE_DAY, path: 'popchat'}), (eventView) ->
      console.log '[Server.coffee]', eventView, '!!!!!!!!!!!!!!!!', eventView.eventTree.events
      eventView.eventTree.print()
    )

  if true
    historicalView = new View({timeSlice: TimeSlice.TEN_MINUTES, path:'popchat', type: 'historical', measurements: 20})
    RedisSink.getHistoricalEventData(historicalView, (eventView) ->
      console.log '[Server.coffee]', eventView
      for event in eventView.eventList
        console.log event.measurements
    )

