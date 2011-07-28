require('./../core/extensions')
redis = require 'redis'
config = require('./../../config').config

TimeExploder = require('./../core/time_exploder').TimeExploder
PathExploder = require('./../core/path_exploder').PathExploder

Event = require('./../models/event').Event
EventView = require('./../models/event_view').EventView
EventListView = require('./../models/event_list_view').EventListView
View = require('./../models/view').View
TimeSlice = require('./../models/time_slice').TimeSlice


class RedisKey
  @namespace = 'rats'

  @scheme: -> "#{@namespace}://"

  @path: (path) -> "#{@scheme()}#{path}"

  @metaKeys: -> @path 'meta/keys'

  @paths: (paths) -> @path(path) for path in paths


class RedisSink

  @redisClient = redis.createClient(config.redis.port, config.redis.host)

  # returns the set of known events
  @listEvents: (view, listEventsCallback) ->
    # todo - filter view path at the redis level. right now, we're filtering after we retrieve from redis
    @redisClient.smembers(RedisKey.metaKeys(), (err, events) =>
      # filter events based on the view path
      filteredEvents = (event for event in events when event.startsWith view.path)
      listEventsCallback(err, filteredEvents)
    )

  @getHistoricalEventData: (view, eventListViewCallback) ->
    time = new Date()
    @listEvents view, (err, eventPaths) =>
      paths = @getTimePaths(time, view.timeSlice, eventPaths, view.measurements)
      redisTimePaths = RedisKey.paths(paths.map (element) -> element.timePath)

      # get events from redis
      @redisClient.mget redisTimePaths, (err, replies) =>
        # create events from the event list

        events = []
        currentEvent = null
        currentPath = ''
        for i in [0..redisTimePaths.length-1]
          if currentPath != paths[i].path
            currentPath = paths[i].path
            currentEvent = new Event({})
            events.push [paths[i].time, replies[i] ? 0]

        eventListView = new EventListView(view, events)
        eventListViewCallback(eventListView)


  # returns an event view
  #  = new View({timeSlice: TimeSlice.ONE_MINUTE, path: Event.ROOT_PATH})
  @getLiveEventData: (view, eventViewCallback) ->
    time = new Date()
    @listEvents view, (err, eventPaths) =>
      paths = @getTimePaths(time, view.timeSlice, eventPaths)
      redisTimePaths = RedisKey.paths(paths.map (element) -> element.timePath)

      # get events from redis
      @redisClient.mget redisTimePaths, (err, replies) =>

        # create events from the event list
        events = []
        for i in [0..redisTimePaths.length-1]
          events.push new Event({path: paths[i].path, count: replies[i] ? 0, redisKey: redisTimePaths[i]})

        eventTree = Event.buildTree view.path, events
        eventView = new EventView(view, eventTree)
        eventViewCallback(eventView)


  # returns (path, timePath)
  @getTimePaths: (time, timeSlice, paths, measurements = 1) ->
    times = TimeExploder.explode(time, timeSlice, measurements)
    timePaths = []
    for path in paths
      for [slice, time] in times
        timePaths.push {path: path, time: time, timeSlice: slice, timePath: @trimSlashes("#{path}/#{slice}/#{time}") }
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





