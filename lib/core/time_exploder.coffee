TimeSlice = require('./../models/time_slice').TimeSlice

class TimeExploder

  @explode: (time, timeSlice = TimeSlice.ALL) ->
    dates = []

    if timeSlice == TimeSlice.ONE_DAY || timeSlice == 'all'
      dates.push "#{TimeSlice.ONE_DAY}/#{@date time}"

    if timeSlice == TimeSlice.ONE_HOUR || timeSlice == 'all'
      dates.push "#{TimeSlice.ONE_HOUR}/#{@date time}T#{@floorHour time}"

    if timeSlice == TimeSlice.TEN_MINUTES || timeSlice == 'all'
      dates.push "#{TimeSlice.TEN_MINUTES}/#{@date time}T#{@hours time}:#{@floorMinutes(time, 10)}:00"

    if timeSlice == TimeSlice.FIVE_MINUTES || timeSlice == 'all'
      dates.push "#{TimeSlice.FIVE_MINUTES}/#{@date time}T#{@hours time}:#{@floorMinutes(time, 5)}:00"

    if timeSlice == TimeSlice.ONE_MINUTE || timeSlice == 'all'
      dates.push "#{TimeSlice.ONE_MINUTE}/#{@date time}T#{@hours time}:#{@padNumber(time.getMinutes())}:00"

    return dates


  @padNumber: (number) ->
    pad = if number < 10 then '0' else ''
    "#{pad}#{number}"

  @date: (time) ->
    "#{time.getFullYear()}-#{@padNumber time.getMonth()+1}-#{time.getDate()}"

  @floorHour: (time) ->
    "#{@padNumber time.getHours()}:00:00"

  @floorMinutes: (time, minutes) ->
    floored = Math.floor(time.getMinutes() / minutes) * minutes
    @padNumber floored

  @hours: (time) -> @padNumber time.getHours()



exports.TimeExploder = TimeExploder