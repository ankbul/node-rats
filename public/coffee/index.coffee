
$(document).ready () ->

  rManager = new RManager('http://localhost',3030, $('#data'))
  rManager.start()

  $('#type_past').click( () ->
    rManager.changeType(RView.VIEW_HISTORICAL)
  )
  $('#type_live').click( () ->
    rManager.changeType(RView.VIEW_LIVE)
  )
  $('#type_future').click( () ->
    rManager.changeType(TimeSlice.ONE_MINUTE)
  )
  $('#timeslice_1minute').click( () ->
    rManager.changeTimeSlice(TimeSlice.ONE_MINUTE)
  )
  $('#timeslice_5minute').click( () ->
    rManager.changeTimeSlice(TimeSlice.FIVE_MINUTES)
  )
  $('#timeslice_10minute').click( () ->
    rManager.changeTimeSlice(TimeSlice.TEN_MINUTES)
  )
  $('#timeslice_1hour').click( () ->
    rManager.changeTimeSlice(TimeSlice.ONE_HOUR)
  )
  $('#timeslice_1day').click( () ->
    rManager.changeTimeSlice(TimeSlice.ONE_DAY)
  )
  $('#navigate_back').click( () ->
    rManager.goBack()
  )






