class RHistorical


  @getGraphDataForEvent: (event) ->
    results   = []
    tooltips  = []
    keys      = []
    colors    = []

    keys.push(event.path)
    colors.push(event.color)
    results.push event.measurements.map((e) -> return e[1]).reverse()
    tooltip = event.measurements.map((e) -> return e[0]).reverse()
    tooltips.push(t) for t in tooltip

    return {
      data      : results,
      tooltips  : tooltips,
      legend    : keys,
      colors    : colors
    }

  @getGraphColor : () ->
    colors = ['rgb(169, 222, 244)', '#3B5998', 'red']
    index = Math.floor(Math.random() * colors.length)
    return colors[index]

  constructor: (data) ->
    @events = []
    for ev in data
      @events.push(new Event(ev, RHistorical.getGraphColor()))

  getGraphData : () ->
    results   = []
    tooltips  = []
    keys      = []
    colors    = []
    for ev in @events
      keys.push(ev.path)
      colors.push(ev.color)
      results.push ev.measurements.map((e) -> return e[1]).reverse()
      tooltip = ev.measurements.map((e) -> return e[0]).reverse()
      tooltips.push(t) for t in tooltip

    return {
      data      : results,
      tooltips  : tooltips,
      legend    : keys,
      colors    : colors
    }

  getByPath : (path) ->
    for ev in @events
      if ev.path == path
        return ev
    return null

  update: (data) ->
    for newEventData in data
      ev = @getByPath(newEventData.path)
      if ev
        ev.update(newEventData)
      else
        @events.push(new Event(newEventData, RHistorical.getGraphColor()))







window.RHistorical = RHistorical




