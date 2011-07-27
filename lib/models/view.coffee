class View

  @VIEW_LIVE = 'live'
  @VIEW_HISTORICAL = 'historical'
  @TIMESLICE_ALL = 'all'

  constructor: (data = {}) ->
    @type = data.type ? View.VIEW_LIVE
    @timeSlice = data.timeSlice ? View.TIMESLICE_ALL
    @path = data.path ? ''


exports.View = View



