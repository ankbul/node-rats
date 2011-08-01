TimeSlice = require('./../models/time_slice').TimeSlice

class TimeExploder

  @MILLISECONDS_PER_MINUTE = 60000
  @MILLISECONDS_PER_SECOND = 1000
  @SECONDS_PER_MINUTE = 60


  # function to do time math
  # returns a timeslice and the number of measurements that convert to the larger timeslice
  @convertToSmallerTimeIncrement: (timeSlice) ->
    switch timeSlice
      when TimeSlice.FIVE_SECONDS then [TimeSlice.ONE_SECOND, TimeSlice.convert(TimeSlice.FIVE_SECONDS, TimeSlice.ONE_SECOND)]
      when TimeSlice.ONE_MINUTE then [TimeSlice.FIVE_SECONDS, TimeSlice.convert(TimeSlice.ONE_MINUTE, TimeSlice.FIVE_SECONDS)]
      #when TimeSlice.FIVE_MINUTES then [TimeSlice.ONE_MINUTE, TimeSlice.convert(TimeSlice.FIVE_MINUTES, TimeSlice.ONE_MINUTE)]
      when TimeSlice.TEN_MINUTES then [TimeSlice.ONE_MINUTE, TimeSlice.convert(TimeSlice.TEN_MINUTES, TimeSlice.ONE_MINUTE)]
      when TimeSlice.ONE_HOUR then [TimeSlice.TEN_MINUTES, TimeSlice.convert(TimeSlice.ONE_HOUR, TimeSlice.TEN_MINUTES)]
      when TimeSlice.ONE_DAY then [TimeSlice.ONE_HOUR, TimeSlice.convert(TimeSlice.ONE_DAY, TimeSlice.ONE_HOUR)]


  @getSecondMultiplier: (timeSlice) ->
    switch timeSlice
      when TimeSlice.ONE_SECOND then 1
      when TimeSlice.FIVE_SECONDS then 5
      when TimeSlice.TEN_SECONDS then 10
      when TimeSlice.ONE_MINUTE then 1*@SECONDS_PER_MINUTE
      when TimeSlice.FIVE_MINUTES then 5*@SECONDS_PER_MINUTE
      when TimeSlice.TEN_MINUTES then 10*@SECONDS_PER_MINUTE
      when TimeSlice.ONE_HOUR then 60*@SECONDS_PER_MINUTE
      when TimeSlice.ONE_DAY then 1440*@SECONDS_PER_MINUTE
      else 1


  @getMinuteMultiplier: (timeSlice) ->
    switch timeSlice
      when TimeSlice.ONE_SECOND   then (1/60)
      when TimeSlice.FIVE_SECONDS then (5/60)
      when TimeSlice.TEN_SECONDS then (10/60)
      when TimeSlice.ONE_MINUTE then 1
      when TimeSlice.FIVE_MINUTES then 5
      when TimeSlice.TEN_MINUTES then 10
      when TimeSlice.ONE_HOUR then 60
      when TimeSlice.ONE_DAY then 1440
      else 1


  @explode: (time, timeSlice, measurements = 1) ->
    datePaths = []
    times = []

    if timeSlice == 'all'
      times.push new Date time
    else
      for i in [0..measurements-1]
        #times.push new Date(time - i*TimeExploder.MILLISECONDS_PER_MINUTE*TimeExploder.getMinuteMultiplier(timeSlice))
        times.push new Date(time - i*TimeSlice.MILLISECONDS_PER_SECOND*TimeSlice.toSeconds(timeSlice))

    for t in times
      explosions = @calculateTimeSlice(t, timeSlice)
      for explosion in explosions
        datePaths.push explosion

    return datePaths


  @calculateTimeSlice: (time, timeSlice = TimeSlice.ALL) ->
    dates = []

    if timeSlice == TimeSlice.ONE_SECOND || timeSlice == 'all'
      dates.push [TimeSlice.ONE_SECOND, "#{@date time} #{@hours time}:#{@padNumber(time.getMinutes())}:#{@padNumber(time.getSeconds())}"]

    if timeSlice == TimeSlice.FIVE_SECONDS || timeSlice == 'all'
      dates.push [TimeSlice.FIVE_SECONDS, "#{@date time} #{@hours time}:#{@padNumber(time.getMinutes())}:#{@floorSeconds(time, 5)}"]

    if timeSlice == TimeSlice.ONE_MINUTE || timeSlice == 'all'
      dates.push [TimeSlice.ONE_MINUTE, "#{@date time} #{@hours time}:#{@padNumber(time.getMinutes())}:00"]

    #if timeSlice == TimeSlice.FIVE_MINUTES || timeSlice == 'all'
    #  dates.push [TimeSlice.FIVE_MINUTES, "#{@date time} #{@hours time}:#{@floorMinutes(time, 5)}:00"]

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

  @floorSeconds: (time, seconds) ->
    floored = Math.floor(time.getSeconds() / seconds) * seconds
    @padNumber floored

  @floorMinutes: (time, minutes) ->
    floored = Math.floor(time.getMinutes() / minutes) * minutes
    @padNumber floored

  @hours: (time) -> @padNumber time.getHours()



exports.TimeExploder = TimeExploder