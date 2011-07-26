
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
    if event.path.startsWith @path
      #console.log "[Event::insert] path = #{@path}, #{@name}"
      if @events.length > 0
        # find the branch to traverse, bfs
        for ev in @events
          if event.path.startsWith ev.path
            #console.log "#{event.path}, #{ev.path}"
            ev.insert event
      else
        @events.push event

    else
      console.log "[Event::insert] skipped! #{event}"


  # builds an event tree from a flattened event list
  @buildFromList: (eventList) ->



exports.Event = Event