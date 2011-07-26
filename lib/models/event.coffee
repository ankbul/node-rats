require './../core/extensions'

class Event
  constructor: (data) ->
    @count    = data.count ? 0
    @name     = data.name ? ''
    @path     = data.path ? ''
    @redisKey = data.redisKey ? ''
    @events   = []

    if data.events
      for event in data.events
        @events.push(new Event(event))


  # walks the tree recursively, until it can insert
  insert: (event) ->
    #console.log 'insert', event, event.path, event['path'], @path
    if event.path.startsWith @path
      # find the branch to traverse, bfs
      parentFound = false
      for child in @events
        if event.path.startsWith child.path
          #console.log "#{event.path}, #{ev.path}"
          child.insert event
          parentFound = true

      if !parentFound
        @events.push event

      #console.log "[Event::insert] path = #{@path}, #{@name}"
#      if @events.length > 0
#      else
#        @events.push event

    else
      console.log "[Event::insert] skipped! #{event}"

  print: (level = 0) ->
    console.log "Level = #{level}", this
    for e in @events
      level += 1
      #console.log "Level = #{level}", e
      e.print level

  @extractNameFromPath: (path) ->
    segments = path.split('/')
    segments[segments.length - 1]


  # builds an event tree from a flattened event list
  @buildFromList: (eventList) ->
    root = new Event({path: '', name: ''})
    return root if eventList.length == 0

    # convert to event objects
    events = eventList
    if typeof eventList[0] == 'string'
      events = (eventList.map (ev) -> new Event {path: ev, name: Event.extractNameFromPath ev})

    # sort the events alphabetically
    events = events.sortByKey 'path'
    root.insert e for e in events
    return root


exports.Event = Event