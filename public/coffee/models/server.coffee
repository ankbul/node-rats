class RServer

  @COMMANDS = {
    CHANGE_VIEW : 'change_view',
    EVENTS      : 'events'
  }

  @EVENT_TYPE_LIVE          = 'live'
  @EVENT_TYPE_HISTORICAL    = 'historical'
  @EVENT_TYPE_DISTRIBUTION  = 'distribution'

  @TIME_INTERVALS = ['1m', '5m']

  constructor: (host, port) ->
    @host = host
    @port = port

    @currentPath      = ''
    @currentType      = RServer.EVENT_TYPE_LIVE
    @currentInterval  = RServer.TIME_INTERVALS[0]

    @eventData = null


  start: () ->
    @socket = io.connect @host+":"+@port
    @socket.on RServer.COMMANDS.EVENTS, (data) =>
      console.log(data)
      @gotEvents(data)
    @changeView @currentPath, @currentType, @currentInterval

  changeView: (path, type, interval) ->
    @currentPath      = path
    @currentType      = type
    @currentInterval  = interval

    view = {
      path      : @currentPath,
      type      : @currentType,
      interval  : @currentInterval
    }

    @eventData = null
    @eventView = null

    @socket.emit RServer.COMMANDS.CHANGE_VIEW, view

  gotEvents: (data) ->

    # check event validation
    if @currentPath != data.view.path || @currentType != data.view.type || @currentInterval != data.view.interval
      console.log('View Information Does not match')
      return

    if data.type = RServer.EVENT_TYPE_LIVE
      if @eventData
        @eventData.update(data)
        @eventView.updateGraph @eventData.toJson()
      else
        @eventData = new REvent(data)
        @eventView = new RLive(@currentPath, @currentInterval)
        $(@eventView).bind(RLive.EVENT_NAVIGATE, (e, data) =>
          @changeView(data.path, data.type, data.interval)
        )
        @eventView.drawGraph @eventData.toJson()




#    console.log data
#    if globalEvent
#      globalEvent.update(data)
#    else
#      globalEvent = new REvent(data)
#    jso = globalEvent.toJson()
#
#    if firstLoad
#      drawGraph jso
#      firstLoad = false
#    else
#      console.log jso



window.RServer = RServer




