RedisSink = require('./redis_sink').RedisSink
FileSink = require('./file_sink').FileSink

class EventSink
  @send: (event) ->
    RedisSink.send event
    FileSink.send event


exports.EventSink = EventSink