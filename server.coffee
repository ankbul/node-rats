config = require('./config').config
EventSource = require('./lib/sources/event_source').EventSource

EventSource.listen()


# set up client


# set up websocket input


#TimeExploder = require('./lib/core/time_exploder').TimeExploder
#d = new Date()
#console.log TimeExploder.explode d


#PathExploder = require('./lib/core/path_exploder').PathExploder
#console.log PathExploder.permute(['female','US','tweener'])
#PathExploder.explode 'parent|master|cheese/foo|bar|baz/57|87|90'

RedisSink = require('./lib/sinks/redis_sink').RedisSink
#RedisSink.listEvents( (err, events) -> console.log events )
time = new Date()
#RedisSink.getEventData(time, () -> console.log "[Server.coffee] callback")
