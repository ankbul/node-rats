socket = require 'socket.io'
RedisSink = require('../sinks/redis_sink').RedisSink
View = require('../models/view').View
TimeSlice = require('../models/time_slice').TimeSlice


class SocketClient

  constructor: (@socket) ->
    @viewType    = View.VIEW_LIVE
    @currentView = new View({timeSlice: TimeSlice.ONE_MINUTE})


  changeView: (path, type, timeSlice) ->
    @viewType = type
    @currentView = new View ({timeSlice: timeSlice, path: path, type: type, measurements: 40})

exports.SocketClient = SocketClient
