RedisSink = require('./redis_sink').RedisSink
FileSink = require('./file_sink').FileSink

class EventSink
  @send: (data) ->
    RedisSink.send data
    FileSink.send data


exports.EventSink = EventSink