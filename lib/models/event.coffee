require './../core/extensions'

class Event
  constructor: (data) ->
    @count    = data.count ? 0
    @path     = data.path ? ''
    @name = data.name ? Event.extractNameFromPath @path
    @redisKey = data.redisKey ? ''
    @events   = []

    if data.events
      for event in data.events
        @events.push(new Event(event))


  # walks the tree recursively, until it can insert
  # this assumes that the object has a place in its hierarchy
  insert: (event) ->
    if event.path.startsWith @path
      # find the branch to traverse, bfs
      parentFound = false
      for child in @events
        if event.path.startsWith child.path
          child.insert event
          parentFound = true

      if !parentFound
        @events.push event

    else
      console.log "[Event::insert] skipped! #{event}"

  print: (level = 0) ->
    console.log "Level: #{level}, Path: #{this.path}, Name: #{this.name}"
    for e in @events
      level += 1
      #console.log "Level = #{level}", e
      e.print level

  @extractNameFromPath: (path) ->
    segments = path.split('/')
    return segments[segments.length - 1]


  # builds an event tree from a flattened event list
  @buildFromList: (eventList) ->
    root = new Event({path: '', name: ''})
    console.log 'Event.coffee::root', root
    return root if eventList.length == 0

    # convert to event objects
    events = eventList
    if typeof eventList[0] == 'string'
      events = (eventList.map (ev) -> new Event {path: ev})

    # sort the events alphabetically
    events = events.sortByKey 'path'
    console.log "[Event]", events
    root.insert e for e in events
    return root


exports.Event = Event