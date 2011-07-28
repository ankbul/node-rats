TimeSlice = require('./../models/time_slice').TimeSlice

class TimeExploder

  @MILLISECONDS_PER_MINUTE = 60000

  @getMinuteMultiplier: (timeSlice) ->
    switch timeSlice
      when TimeSlice.ONE_MINUTE then 1
      when TimeSlice.FIVE_MINUTES then 5
      when TimeSlice.TEN_MINUTES then 10
      when TimeSlice.ONE_HOUR then 60
      when TimeSlice.ONE_DAY then 1440
      else 1


  @explode: (time, timeSlice, measurements = 1) ->
    datePaths = []
    times = []

    for i in [0..measurements-1]
      times.push new Date(time - i*TimeExploder.MILLISECONDS_PER_MINUTE*TimeExploder.getMinuteMultiplier(timeSlice))

    for t in times
      explosions = @calculateTimeSlice(t, timeSlice)
      for explosion in explosions
        datePaths.push explosion

    return datePaths


  @calculateTimeSlice: (time, timeSlice = TimeSlice.ALL) ->
    dates = []

    if timeSlice == TimeSlice.ONE_MINUTE || timeSlice == 'all'
      dates.push [TimeSlice.ONE_MINUTE, "#{@date time} #{@hours time}:#{@padNumber(time.getMinutes())}:00"]

    if timeSlice == TimeSlice.FIVE_MINUTES || timeSlice == 'all'
      dates.push [TimeSlice.FIVE_MINUTES, "#{@date time} #{@hours time}:#{@floorMinutes(time, 5)}:00"]

    if timeSlice == TimeSlice.TEN_MINUTES || timeSlice == 'all'
      dates.push [TimeSlice.TEN_MINUTES, "#{@date time} #{@hours time}:#{@floorMinutes(time, 10)}:00"]

    if timeSlice == TimeSlice.ONE_HOUR || timeSlice == 'all'
      dates.push [TimeSlice.ONE_HOUR, "#{@date time} #{@floorHour time}"]

    if timeSlice == TimeSlice.ONE_DAY || timeSlice == 'all'
      dates.push [TimeSlice.ONE_DAY, "#{@date time}"]

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