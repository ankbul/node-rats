require './lib/core/extensions'
express = require 'express'
socket = require 'socket.io'
config = require('./config').config
SocketClient = require('./lib/client/socket_client').SocketClient
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
socketClient = new SocketClient config.socket.port
#socketClient.listen()




#PathExploder = require('./lib/core/path_exploder').PathExploder
#console.log PathExploder.permute(['female','US','tweener'])
#PathExploder.explode 'parent|master|cheese/foo|bar|baz/57|87|90'

Event = require('./lib/models/event').Event

#root = new Event({path: '', name: 'root'})
#popchat = new Event({path: 'popchat', name: 'popchat'})
#root.insert popchat
#popchatlogin = new Event({path:'popchat/login', name:'login'})
#root.insert popchatlogin
#popchatloginnew = new Event({path:'popchat/login/new', name:'new'})
#root.insert popchatloginnew
#eventList = [popchat, popchatlogin, popchatloginnew]
#console.log '[Server.coffee]', Event.buildFromList eventList


#TimeExploder = require('./lib/core/time_exploder').TimeExploder
#d = new Date()
#console.log TimeExploder.explode d, TimeSlice.ONE_MINUTE, 10


if true

  RedisSink = require('./lib/sinks/redis_sink').RedisSink

  if false
    RedisSink.getLiveEventData(new View({timeSlice: TimeSlice.ONE_DAY, path:'popchat'}), (eventView) ->
      console.log '[Server.coffee]', eventView, '!!!!!!!!!!!!!!!!', eventView.eventTree.events
      eventView.eventTree.print()
    )

  if true
    historicalView = new View({timeSlice: TimeSlice.FIVE_SECONDS, path:'popchat', type: 'historical', measurements: 20})
    RedisSink.getHistoricalEventData(historicalView, (eventView) ->
      console.log '[Server.coffee]', eventView
      for event in eventView.eventList
        console.log event.measurements
    )



