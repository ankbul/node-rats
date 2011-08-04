class RManager

  constructor: (@host, @port = 3030, @container) ->
    @currentPath        = '/'
    @currentType        = RView.VIEW_LIVE
    @currentTimeSlice   = TimeSlice.ONE_MINUTE

    @eventData = null
    @historyStack = []

  start: () ->
    @socket = io.connect @host+":"+@port

    @socket.on Commands.CONNECTED, (data) =>
      @changeView()

    @socket.on Commands.EVENTS, (data) =>
      @gotEvents(data)

  bindBreadcrumClick : (div, globalPath, path) ->
    newPath = globalPath + path + '/'
    div.click () =>
      @changePath(newPath)

  generateBreadCrums : (path) ->
    $('#breadcrums').empty()
    paths = path.split('/')
    paths = paths[0..paths.length-2]

    globalPath = ''
    ul = $('<ul>')
    for path in paths
      li = $('<li>')
      @bindBreadcrumClick(li, globalPath, path)
      globalPath = globalPath + path + '/'
      li.html(path + '/')
      ul.append(li)
    $('#breadcrums').append(ul)

  goBack : () ->
    path = @historyStack.pop()
    if (path == '') || (path != undefined)
      @changeView path

  changeTimeSlice: (timeSlice) ->
    @changeView null, null, timeSlice

  changePath : (path) ->
    @historyStack.push @currentPath
    @changeView path

  changeType : (type) ->
    @changeView null, type, null

  changeView: (path, type, timeSlice) ->
    if path
      @generateBreadCrums(path)

    @container.empty()
    @eventData = null
    @eventView = null

    if path != undefined && path != null
      @currentPath        = path
    @currentType        = type || @currentType
    @currentTimeSlice   = timeSlice || @currentTimeSlice


    view = {
      path        : @currentPath,
      type        : @currentType,
      timeSlice  : @currentTimeSlice
    }

    @socket.emit Commands.CHANGE_VIEW, view

  gotEvents: (data) ->
    console.log data
#    console.log @currentPath
#    console.log @currentType
#    console.log @currentTimeSlice
#
#    console.log data.view.path
#    console.log data.view.type
#    console.log data.view.timeSlice

    # check event validation
    if @currentPath != data.view.path || @currentType != data.view.type || @currentTimeSlice != data.view.timeSlice
      console.log('View Information Does not match')
      return

    if @eventData
      @eventData.update(data.eventTree)
    else
      @eventData = new Event(data.eventTree)
      switch data.view.type
        when RView.VIEW_LIVE
          @eventView = new RLive(@currentPath, @currentTimeSlice)
          $(@eventView).bind(RLive.EVENT_NAVIGATE, (e, data) =>
            @changePath data.path
          )
        when RView.VIEW_HISTORICAL
          @eventView = new RPast(@currentPath, @currentTimeSlice)

    @eventView.draw @eventData




#    if data.view.type == RView.VIEW_LIVE
#      if @eventData
#        @eventData.update(data.eventTree)
#        @eventView.updateGraph @eventData
#      else
#        @eventData = new Event(data.eventTree)
#        @eventView = new RLive(@currentPath, @currentTimeSlice)
#        $(@eventView).bind(RLive.EVENT_NAVIGATE, (e, data) =>
#          @changePath data.path
#        )
#        @eventView.drawGraph @eventData
#
#
#    else if data.view.type = RView.VIEW_HISTORICAL
#      if @eventData
#        @eventData.update(data.eventList)
#      else
#        @eventData = new RHistorical(data.eventList)
#
#      nowData   = @eventData.getGraphData(RHistorical.NOW_DATA)
#      prevData  = @eventData.getGraphData(RHistorical.PAST_DATA)
#
#
#      RPast.drawGraph nowData, 'past'
#      RPast.drawExpandedData prevData

window.RManager = RManager




