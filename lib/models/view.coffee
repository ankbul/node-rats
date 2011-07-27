TimeSlice = require('./time_slice').TimeSlice

class View

  @VIEW_LIVE = 'live'
  @VIEW_HISTORICAL = 'historical'


  constructor: (data = {}) ->
    @type = data.type ? View.VIEW_LIVE
    @timeSlice = data.timeSlice ? TimeSlice.ALL
    @path = data.path ? Event.ROOT_PATH


exports.View = View



