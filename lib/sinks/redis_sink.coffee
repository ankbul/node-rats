redis = require 'redis'
config = require('./../../config').config

TimeExploder = require('./../core/time_exploder').TimeExploder
PathExploder = require('./../core/path_exploder').PathExploder

# AB : todo - expire keys

class EventParser
  @parse: (event) ->
    times = TimeExploder.explode event.time


class RedisKey
  @namespace = 'rats'

  @scheme: -> "#{@namespace}://"

  @path: (path) -> "#{@scheme()}#{path}"

  @metaKeys: -> @path 'meta/keys'


class RedisSink

  @redisClient = redis.createClient(config.redis.port, config.redis.host)

  @send: (event) ->
    bucket = event.data.b
    uid = "#{event.data.uid}"
    times = TimeExploder.explode(event.time)
    paths = PathExploder.explode(event.data.e)
    testGroup = event.data.tg
    testPath = event.data.tp

    # build a list of increments
    timePaths = []
    for path in paths
      for timeIncrement in times
        timePaths.push "#{path}/#{timeIncrement}".replace(/^\/+/,'')

    bucketPaths = ("#{bucket}/#{path}" for path in timePaths)

    # build the meta list of events to add to the set
    metaPaths = ("#{bucket}/#{path}" for path in paths)

    # AB : todo we shouldn't have save this meta set everytime
    # save the meta to redis
    @redisClient.sadd(RedisKey.metaKeys(), metaPath) for metaPath in metaPaths

    # save the increments to redis
    @redisClient.incrby(RedisKey.path(bucketPath), 1) for bucketPath in bucketPaths


    # build the distribution numbers
#    if uid.length > 1
#      console.log "[RedisSink] uid = #{uid}"


    #console.log "event = #{event.data.e}, uid = #{event.data.uid}"

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





