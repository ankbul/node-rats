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
Path = require('./../models/path').Path


class RedisKey
  @namespace = 'rats'

  @scheme: -> "#{@namespace}://"

  @path: (path) -> "#{@scheme()}#{path}"

  @metaKeys: -> @path 'meta/keys'

  @paths: (paths) -> @path(path) for path in paths


class RedisSink

  @redisClient = redis.createClient(config.redis.port, config.redis.host)

  # returns the set of known events
  # AB todo - use the in-memory tree, rather than from redis
  @listEvents: (view, depth, listEventsCallback) ->
    currentDepth = Path.getDepth view.path

    @redisClient.zrange(RedisKey.metaKeys(), currentDepth, currentDepth + depth, (err, events) =>
      throw new Error(err) if err
      console.log '[listEvents]', events
      # filter events based on the view path
      filteredEvents = (event for event in events when event.startsWith view.path)
      listEventsCallback(err, filteredEvents)
    )

  @getHistoricalEventData: (view, eventListViewCallback) ->
    time = new Date()
    @listEvents view, 1, (err, eventPaths) =>
      # no events, no historical data
      if eventPaths.length == 0
        eventListViewCallback(new EventListView(view, []))
        return

      paths = @getTimePaths(time, view.timeSlice, eventPaths, view.measurements)
      #console.log '[getHistoricalEventData::paths]', paths
      redisTimePaths = RedisKey.paths(paths.map (element) -> element.timePath)
      #console.log '[getHistoricalEventData::redisTimePaths]', redisTimePaths

      # get events from redis
      @redisClient.mget redisTimePaths, (err, replies) =>
        # create events from the event list

        events = []
        currentEvent = null
        currentPath = ''
        for i in [0..redisTimePaths.length-1]
          if currentPath != paths[i].path
            currentPath = paths[i].path
            currentEvent = new Event({path: paths[i].path})
            events.push currentEvent

          currentEvent.measurements.push [paths[i].time, replies[i] ? 0]

        eventListView = new EventListView(view, events)
        eventListViewCallback(eventListView)


  # returns an event view
  #  = new View({timeSlice: TimeSlice.ONE_MINUTE, path: Event.ROOT_PATH})
  @getLiveEventData2: (view, eventViewCallback) ->
    time = new Date()
    @listEvents view, Event.MAX_DEPTH, (err, eventPaths) =>
      smallerTimeSlice = TimeExploder.convertToSmallerTimeIncrement view.timeSlice
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


  # returns an event view
  #  = new View({timeSlice: TimeSlice.ONE_MINUTE, path: Event.ROOT_PATH})
  @getLiveEventData: (view, eventViewCallback) ->
    #console.log "[RedisSink::getLiveEventData]"
    time = new Date()
    @listEvents view, 1, (err, eventPaths) =>
      if eventPaths.length == 0
        eventViewCallback(new EventView(view, new Event {}))
        return

      paths = @getTimePaths(time, view.timeSlice, eventPaths)
      redisTimePaths = RedisKey.paths(paths.map (element) -> element.timePath)

      console.log '[redisTimePaths]', redisTimePaths

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
  # paths are an array of {path: , depth: } hashes
  @getTimePaths: (time, timeSlice, paths, measurements = 1) ->
    times = TimeExploder.explode(time, timeSlice, measurements)
    timePaths = []
    for path in paths
      for [slice, time] in times
        p = path.path ? path
        timePaths.push {
          path: p, time: time,
          timeSlice: slice,
          timePath: Path.sanitize("#{p}/#{slice}/#{time}".surround(Event.PATH_SEPARATOR))
        }
    timePaths

  @send: (event) ->
    # todo - have a class to represent this stuff
    #bucket = event.data.b
    uid = "#{event.data.uid}"
    test = event.data.t
    testPath = event.data.tp
    funnel = event.data.f
    funnelStep = event.data.fs
    paths = PathExploder.explode(event.data.e)

    # build the meta list of events to add to the set
    # remove trail
    # AB : todo - shouldn't be doing path manipulation here
    # AB : todo we shouldn't have save this meta set every time
    # save the meta to redis
    #metaPaths = ( Path.sanitize("#{bucket}#{path}".surround(Event.PATH_SEPARATOR)) for path in paths)
    #@redisClient.sadd(RedisKey.metaKeys(), metaPath) for metaPath in metaPaths
    @redisClient.zadd(RedisKey.metaKeys(), path.depth, path.path) for path in paths #when path.depth > 0

    # build a list of increments
    timePaths = (@getTimePaths event.time, 'all', paths).map (element) -> element.timePath

    # AB : todo - shouldn't be doing path manipulation here
    # save the increments to redis
    #bucketPaths = ( Path.sanitize("#{bucket}#{path}".surround(Event.PATH_SEPARATOR)) for path in timePaths)
    #@redisClient.incrby(RedisKey.path(bucketPath), 1) for bucketPath in bucketPaths
    @redisClient.incrby(RedisKey.path(timePath), 1) for timePath in timePaths


    # build the distribution numbers
#    if uid.length > 1
#      console.log "[RedisSink] uid = #{uid}"


exports.RedisSink = RedisSink

