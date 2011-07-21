redis = require 'redis',
Listener = require('./lib/listeners/listener').Listener

config =
  redis:
    port: 6379
    host: '127.0.0.1'

class EventBuffer
  # pushes data to async.queue as fast as possible
  @buffer: (data) ->
    console.log "Incoming request: #{data}"



Listener.listen()

#class EventPipe

#class RedisEventPipe extends EventPipe

#class FileEventPipe extends EventPipe


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



