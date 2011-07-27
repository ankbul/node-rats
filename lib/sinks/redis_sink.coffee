require('./../core/extensions')
redis = require 'redis'
config = require('./../../config').config

TimeExploder = require('./../core/time_exploder').TimeExploder
PathExploder = require('./../core/path_exploder').PathExploder

Event = require('./../models/event').Event
EventView = require('./../models/event_view').EventView
View = require('./../models/view').View



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

  # returns the set of known events
  @listEvents: (callback) ->
    @redisClient.smembers(RedisKey.metaKeys(), (err, events) -> callback(err, events))


  # returns an event view
  @getLiveEventData: (timeSlice = '1m', callback) ->
    time = new Date()
    @listEvents (err, eventPaths) =>
      #console.log events
      paths = @getTimePaths(time, timeSlice, eventPaths)
      redisTimePaths = RedisKey.paths(paths.map (element) -> element.timePath)

      #console.log timePaths
      @redisClient.mget redisTimePaths, (err, replies) =>

        # build an event list
        events = []
        for i in [0..redisTimePaths.length-1]
          #console.log "#{i} = #{paths[i]}"
          #path = (path for path in paths when path.timePath == timePaths[i])
          # create events
          event = new Event({path: paths[i].path, count: replies[i], redisKey: redisTimePaths[i]})
          events.push event

        #console.log events
        # convert event list to event view
        eventView = new EventView(new View(), Event.buildFromList events)
        callback(events)



  # returns (path, timePath)
  @getTimePaths: (time, timeSlice, paths) ->
    times = TimeExploder.explode(time, timeSlice)
    timePaths = []
    for path in paths
      for timeIncrement in times
        timePaths.push {path: path, timePath: @trimSlashes("#{path}/#{timeIncrement}") }
    timePaths


  @trimSlashes: (string) -> string.replace(/^\/+|\/+$/g,'')


  @send: (event) ->
    bucket = event.data.b
    uid = "#{event.data.uid}"

    paths = PathExploder.explode(event.data.e)
    testGroup = event.data.tg
    testPath = event.data.tp

    # build a list of increments
    timePaths = (@getTimePaths event.time, 'all', paths).map (element) -> element.timePath
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





