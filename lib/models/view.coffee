TimeSlice = require('./time_slice').TimeSlice
Event     = require('./event').Event

class View

  @VIEW_LIVE = 'live'
  @VIEW_HISTORICAL = 'historical'

  constructor: (data = {}) ->
    @type = data.type ? View.VIEW_LIVE
    @timeSlice = data.timeSlice ? TimeSlice.ALL
    @path = data.path ? Event.ROOT_PATH
    @measurements = data.measurements ? 100


exports.View = View



