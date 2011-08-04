require './lib/core/extensions'
config = require('./config').config

# set up the event listeners
EventSource = require('./lib/sources/event_source').EventSource
TimeSlice = require('./lib/models/time_slice').TimeSlice
Event = require('./lib/models/event').Event
View = require('./lib/models/view').View
EventSource.listen()


# set up website
express = require 'express'
app = express.createServer();
app.use express.static __dirname + '/public'
app.listen(config.express.port)


# set up websocket input
socket = require 'socket.io'
SocketManager = require('./lib/client/socket_manager').SocketManager
socketManager = new SocketManager config.socket.port
socketManager.listen()



# testing
if false

  RedisSink = require('./lib/sinks/redis_sink').RedisSink

  testLiveEventData = () ->
    RedisSink.getLiveEventData(new View({timeSlice: TimeSlice.ONE_DAY, path: 'popchat'}), (eventView) ->
      console.log '[Server.coffee]', eventView, '!!!!!!!!!!!!!!!!', eventView.eventTree.events
      eventView.eventTree.print()
    )

  testRollingEventData = () ->
    RedisSink.getRollingLiveEventData(new View({timeSlice: TimeSlice.ONE_MINUTE, path: 'wallpost'}), (eventView) ->
      #console.log '[Server.coffee]', eventView, '!!!!!!!!!!!!!!!!', eventView.eventTree.events
      eventView.eventTree.print()
    )

  testHistoricalEventData = () ->
    historicalView = new View({timeSlice: TimeSlice.TEN_MINUTES, path:'popchat', type: 'historical', measurements: 20})
    RedisSink.getHistoricalEventData(historicalView, (eventView) ->
      console.log '[Server.coffee]', eventView
      for event in eventView.eventList
        console.log event.measurements
    )

  if true
    testRollingEventData()
    #setInterval(testRollingEventData, 5000)

  if false
    testHistoricalEventData()
