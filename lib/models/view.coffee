require './../core/extensions'
TimeSlice = require('./time_slice').TimeSlice
Event = require('./event').Event


class View

  @VIEW_LIVE = 'live'
  @VIEW_HISTORICAL = 'historical'

  constructor: (data = {}) ->
    @type = data.type ? View.VIEW_LIVE
    @timeSlice = data.timeSlice ? TimeSlice.ALL

    # make sure we don't add 3 slashes
    path = data.path ? Event.ROOT_PATH
    if path != Event.ROOT_PATH
      path = path.surround Event.PATH_SEPARATOR

    @path = path
    @measurements = data.measurements ? 100


exports.View = View



