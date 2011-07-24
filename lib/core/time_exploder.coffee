class TimeExploder

  @explode: (time) ->
    dates = []
    # add today
    dates.push "day/#{@date time}"

    # add this hour
    dates.push "hour/#{@date time}T#{@floorHour time}"

    # add last 10 min
    dates.push "10m/#{@date time}T#{@hours time}:#{@floorMinutes(time, 10)}:00"

    # add last 5 min
    dates.push "5m/#{@date time}T#{@hours time}:#{@floorMinutes(time, 5)}:00"

    # add last 1 min
    dates.push "1m/#{@date time}T#{@hours time}:#{@padNumber(time.getMinutes())}:00"

    dates


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