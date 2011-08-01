
# todo - make this into a dynamic system, e.g. s = seconds, m = minutes, h = hours, d = days
class TimeSlice
  @MILLISECONDS_PER_SECOND = 1000
  @SECONDS_PER_MINUTE = 60
  @SECONDS_PER_HOUR = 3600
  @SECONDS_PER_DAY = 86400

  @ALL          = 'all'
  @ONE_SECOND   = '1s'
  @FIVE_SECONDS = '5s'
  @TEN_SECONDS  = '10s'
  @ONE_MINUTE   = '1m'
  @FIVE_MINUTES = '5m'
  @TEN_MINUTES  = '10m'
  @ONE_HOUR     = '1h'
  @ONE_DAY      = '1d'


  # converts a human-readable timeScale to seconds, e.g. (5s = 5 seconds, 1d = 86400, etc)
  @toSeconds: (timeSlice) ->
    split = timeSlice.split 's'
    if split.length == 2
      return split[0]

    split = timeSlice.split 'm'
    if split.length == 2
      return split[0] * TimeSlice.SECONDS_PER_MINUTE

    split = timeSlice.split 'h'
    if split.length == 2
      return split[0] * TimeSlice.SECONDS_PER_HOUR

    split = timeSlice.split 'd'
    if split.length == 2
      return split[0] * TimeSlice.SECONDS_PER_DAY

    throw new Error("TimeSlice not supported: #{timeSlice}")


  @convert: (fromTimeSlice, toTimeSlice) ->
    fromSeconds = TimeSlice.toSeconds fromTimeSlice
    toSeconds = TimeSlice.toSeconds toTimeSlice
    return fromSeconds / toSeconds





exports.TimeSlice = TimeSlice