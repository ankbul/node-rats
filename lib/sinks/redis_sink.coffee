redis = require 'redis'
config = require('./../../config').config

# AB : todo - explode into different time components
# AB : todo - explode into




class EventExploder
  @explode: (path) ->



class EventParser
  @parse: (event) ->
    times = TimeExploder.explode event.time




class RedisSink

  @redisClient = redis.createClient(config.redis.port, config.redis.host)

  @send: (event) ->
    console.log
    #console.log "[RedisSink] #{data}"


exports.RedisSink = RedisSink



#client = redis.createClient(config.redis.port, config.redis.host)

#client.on('error', (err) -> console.log "Error " + err )

#client.set 'string key2', 'string val', redis.print
#client.hset 'hash key', 'hashtest 2', "some value", redis.print
#client.hset ['hash key', 'hashtest 2', 'some other value'], redis.print
#client.hgetall 'hash key', redis.print

#client.hkeys('hash key', (err, replies) ->
#    console.log "#{replies.length} replies:"
#    replies.forEach((reply, i) -> console.log "#{i}: #{reply}")
#    client.quit
#)





