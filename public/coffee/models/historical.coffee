class RHistorical

  @ALL_DATA   = 'all'
  @NOW_DATA   = 'now'
  @PAST_DATA  = 'past'

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

  getGraphData : (type = RHistorical.ALL_DATA) ->
    results   = []
    tooltips  = []
    keys      = []
    colors    = []
    for ev in @events
      measurements = ev.measurements.map((e) -> return e[1])
      tooltip = ev.measurements.map((e) -> return e[0])

      switch type
        when RHistorical.NOW_DATA
          measurements = measurements.slice(0, measurements.length / 2)
          tooltip      = tooltip.slice(0, tooltip.length / 2)
        when RHistorical.PAST_DATA
          measurements = measurements.slice(measurements.length / 2)
          tooltip      = tooltip.slice(tooltip.length / 2)

      results.push measurements.reverse()
      tooltips.push(t) for t in tooltip.reverse()
      keys.push(ev.path)
      colors.push(ev.color)

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




