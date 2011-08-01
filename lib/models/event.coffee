require './../core/extensions'

class Event
  @ROOT_PATH = '/'
  @PATH_SEPARATOR = '/'
  @DIMENSION_SEPARATOR = '|'
  @MAX_DEPTH = 20

  constructor: (data) ->
    @count          = data.count ? 0
    @previousCount  = data.previousCount ? 0
    @path           = data.path ? Event.ROOT_PATH
    @name           = data.name ? Event.extractNameFromPath @path
    @redisKey       = data.redisKey ? ''
    @events         = []
    @measurements   = []

    if data.events
      for event in data.events
        @events.push(new Event(event))


  # walks the tree recursively, until it can insert
  # this assumes that the object has a place in its hierarchy
  insert: (event) ->
    #console.log "[INSERT] inserting #{event.path} into #{@path}"
    if event.path.startsWith @path
      # find the branch to traverse, bfs
      parentFound = false
      for child in @events
        if event.path.startsWith child.path
          child.insert event
          parentFound = true
          #break

      if !parentFound
        @events.push event

    else
      console.log "[Event::insert] skipped! #{event}"

  print: (level = 0) ->
    console.log "Level: #{level}, Path: #{@path}, Name: #{@name}, Count: #{@count}, PreviousCount: #{@previousCount}"
    e.print level+1 for e in @events


  @extractNameFromPath: (path) ->
    segments = path.trimSlashes().split(Event.PATH_SEPARATOR)
    return segments[segments.length - 1]


  # builds an event tree from a flattened event list
  @buildTree: (path, eventList) ->
    root = new Event({path: Event.ROOT_PATH, name: ''})
    return root if eventList.length == 0

    # convert to event objects
    events = eventList
    if typeof eventList[0] == 'string'
      events = (eventList.map (ev) -> new Event {path: ev})

    #console.log '[buildTree]', events
    events = events.sortByKey 'path'

    if events[0].path == Event.ROOT_PATH
      root = events[0]
      events = events[1..events.length-1]

    for e in events
      root.insert e
      #console.log "EVENT:INSERT #{e.path} into #{root.path}"

    return root if path == Event.ROOT_PATH
    return root.events[0]


exports.Event = Event