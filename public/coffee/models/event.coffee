class REvent
  constructor: (data) ->
    @count  = data.count || 0
    @name   = data.name || ''
    @path   = data.path || ''
    @events = []

    if data.events
      for ev in data.events
        @events.push(new REvent(ev))


  toJson: () ->
    data = []

    maxRange = -1

    for event in @events
      maxRange = event.count if event.count > maxRange

    data = []
    for event in @events
      data.push({
        title     :event.name,
        subtitle  : "Count " + event.count,
        ranges    :[maxRange],
        measures  :[event.count],
        markers   :[maxRange],
        obj       : event
      })

    return data

  getEvent: (path) ->
    for event in @events
      if event.path == path
        return event
    return null

  update: (data) ->
    @count = data.count || 0
    @name   = data.name || ''
    @path   = data.path || ''
    if !data.events
      @events = []
      return

    for newEventData in data.events
      ev = @getEvent newEventData.path

      if ev == null
        @events.push new REvent(newEventData)
      else
        ev.update(newEventData)



window.REvent = REvent




