class Event

  @getGraphColor : () ->
    colors = ['rgb(169, 222, 244)', '#3B5998', 'red']
    index = Math.floor(Math.random() * colors.length)
    return colors[index]

  constructor: (data, color) ->
    @events        = []
    @count         = data.count ? 0
    @name          = data.name ? ''
    @path          = data.path ? ''
    @color         = color ? Event.getGraphColor()
    @measurements  = data.measurements ? []
    @previousCount = data.previousCount ? 0
    if data.events
      for ev in data.events
        @events.push new Event(ev)

  update: (data) ->
    @count          = data.count || 0
    @name           = data.name || ''
    @path           = data.path || ''
    @measurements   = data.measurements ? []
    @previousCount  = data.previousCount ? 0

    if !data.events
      @events = []
      return

    for evData in data.events
      ev = @getByPath evData.path
      if ev == null
        @events.push new Event(evData)
      else
        ev.update(evData)

  getByPath: (path) ->
    for event in @events
      if event.path == path
        return event
    return null

  getGraphLiveData: (showPrevious = false) ->
    @nowData      = @measurements.slice(0, @measurements.length / 2)
    @previousData = @measurements.slice(@measurements.length / 2)
    graphData = {
      data      : [@nowData.map((e) -> return e[1]).reverse()],
      tooltips  : @nowData.map((e) -> return e[0]).reverse(),
      legend    : [@path],
      colors    : [@color]
    }
    if showPrevious
      graphData.data      = [@previousData.map((e) -> return e[1]).reverse()].concat(graphData.data)
      graphData.tooltips  = @previousData.map((e) -> return e[0]).reverse().concat(graphData.tooltips)
      graphData.colors    = ['#CCC'].concat(graphData.colors)
      graphData.legend    = ['past'].concat(graphData.legend)

    return graphData

  getGraphData : (type = RView.ALL_DATA) ->
    measurements  = @measurements.map((e) -> return e[1])
    tooltip       = @measurements.map((e) -> return e[0])

    switch type
      when RView.NOW_DATA
        measurements = measurements.slice(0, measurements.length / 2)
        tooltip      = tooltip.slice(0, tooltip.length / 2)
      when RView.PAST_DATA
        measurements = measurements.slice(measurements.length / 2)
        tooltip      = tooltip.slice(tooltip.length / 2)

    graphData = {
      data      : measurements,
      tooltips  : tooltip,
      legend    : @path,
      colors    : @color
    }

  getSubEventsGraphData : (type = RView.ALL_DATA) ->
    results   = []
    tooltips  = []
    keys      = []
    colors    = []
    for ev in @events
      measurements  = ev.measurements.map((e) -> return e[1])
      tooltip       = ev.measurements.map((e) -> return e[0])

      switch type
        when RView.NOW_DATA
          measurements = measurements.slice(0, measurements.length / 2)
          tooltip      = tooltip.slice(0, tooltip.length / 2)
        when RView.PAST_DATA
          measurements = measurements.slice(measurements.length / 2)
          tooltip      = tooltip.slice(tooltip.length / 2)

      results.push measurements.reverse()
      tooltips.push(t) for t in tooltip.reverse()
      keys.push(ev.path)
      colors.push(ev.color)

    graphData = {
      data      : results,
      tooltips  : tooltips,
      legend    : keys,
      colors    : colors
    }

    return graphData



window.Event = Event




