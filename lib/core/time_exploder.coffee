class TimeExploder

  @explode: (time, timeSlice = 'all') ->
    dates = []

    if timeSlice == 'day' || timeSlice == 'all'
      dates.push "day/#{@date time}"

    if timeSlice == 'hour' || timeSlice == 'all'
      dates.push "hour/#{@date time}T#{@floorHour time}"

    if timeSlice == '10m' || timeSlice == 'all'
      dates.push "10m/#{@date time}T#{@hours time}:#{@floorMinutes(time, 10)}:00"

    if timeSlice == '5m' || timeSlice == 'all'
      dates.push "5m/#{@date time}T#{@hours time}:#{@floorMinutes(time, 5)}:00"

    if timeSlice == '1m' || timeSlice == 'all'
      dates.push "1m/#{@date time}T#{@hours time}:#{@padNumber(time.getMinutes())}:00"

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