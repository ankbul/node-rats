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

  @paths: (paths) -> @path(path) for path in paths


class RedisSink

  @redisClient = redis.createClient(config.redis.port, config.redis.host)

  @listEvents: (callback) ->
    @redisClient.smembers(RedisKey.metaKeys(), (err, events) -> callback(err, events))

  @getEventData: (time, callback) ->
    @listEvents (err, events) =>
      #console.log events
      timePaths = RedisKey.paths(@getTimePaths time, events)
      console.log timePaths
      @redisClient.mget timePaths, (err, replies) -> console.log err, replies


  @getTimePaths: (time, paths) ->
    times = TimeExploder.explode(time)
    timePaths = []
    for path in paths
      for timeIncrement in times
        timePaths.push "#{path}/#{timeIncrement}".replace(/^\/+/,'')
    timePaths



  @trimSlashes: (string) ->
    string.replace(/^\/+|\/+$/g,'')


  @send: (event) ->
    bucket = event.data.b
    uid = "#{event.data.uid}"

    paths = PathExploder.explode(event.data.e)
    testGroup = event.data.tg
    testPath = event.data.tp

    # build a list of increments
    timePaths = @getTimePaths event.time, paths
    #times = TimeExploder.explode(event.time)
    #timePaths = []
    #for path in paths
    #  for timeIncrement in times
    #    timePaths.push "#{path}/#{timeIncrement}".replace(/^\/+/,'')

    bucketPaths = ( @trimSlashes("#{bucket}/#{path}") for path in timePaths)

    # build the meta list of events to add to the set
    # remove trail
    metaPaths = ( @trimSlashes("#{bucket}/#{path}") for path in paths)

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





