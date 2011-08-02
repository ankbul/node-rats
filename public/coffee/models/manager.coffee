class RManager

  @COMMANDS = {
    CHANGE_VIEW : 'change_view',
    EVENTS      : 'events'
  }

  @EVENT_TYPE_LIVE          = 'live'
  @EVENT_TYPE_HISTORICAL    = 'historical'
  @EVENT_TYPE_DISTRIBUTION  = 'distribution'

  constructor: (@host, @port = 3030, @container) ->

    @currentPath        = '/'
    @currentType        = RView.VIEW_LIVE
    @currentTimeSlice   = TimeSlice.ONE_MINUTE

    @eventData = null

    @historyStack = []


  start: () ->
    @socket = io.connect @host+":"+@port

    @socket.on 'connection', (data) =>
      @changeView()

    @socket.on RManager.COMMANDS.EVENTS, (data) =>
      @gotEvents(data)

  goBack : () ->
    path = @historyStack.pop()
    if (path == '') || (path != undefined)
      @changeView path

  changeTimeSlice: (timeSlice) ->
    @changeView null, null, timeSlice

  changePath : (path) ->
    @historyStack.push(@currentPath)
    @changeView path

  changeType : (type) ->
    alert('changing type ' + type)
    @changeView null, type, null

  changeView: (path, type, timeSlice) ->
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

    @socket.emit RManager.COMMANDS.CHANGE_VIEW, view

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

    if data.view.type == RView.VIEW_LIVE
      if @eventData
        @eventData.update(data.eventTree)
        @eventView.updateGraph @eventData
      else
        @eventData = new REvent(data.eventTree)
        @eventView = new RLive(@currentPath, @currentTimeSlice)
        $(@eventView).bind(RLive.EVENT_NAVIGATE, (e, data) =>
          @changePath data.path
        )
        @eventView.drawGraph @eventData


    else if data.view.type = RView.VIEW_HISTORICAL
      if @eventData
        @eventData.update(data.eventList)
      else
        @eventData = new RHistorical(data.eventList)

      graphData = @eventData.getGraphData()
      RPast.drawGraph graphData



window.RManager = RManager




