(function() {
  $(document).ready(function() {
    var rManager;
    rManager = new RManager('http://localhost', 3030, $('#data'));
    rManager.start();
    $('#type_past').click(function() {
      return rManager.changeType(RView.VIEW_HISTORICAL);
    });
    $('#type_live').click(function() {
      return rManager.changeType(RView.VIEW_LIVE);
    });
    $('#type_future').click(function() {
      return rManager.changeType(TimeSlice.ONE_MINUTE);
    });
    $('#timeslice_1minute').click(function() {
      return rManager.changeTimeSlice(TimeSlice.ONE_MINUTE);
    });
    $('#timeslice_5minute').click(function() {
      return rManager.changeTimeSlice(TimeSlice.FIVE_MINUTES);
    });
    $('#timeslice_10minute').click(function() {
      return rManager.changeTimeSlice(TimeSlice.TEN_MINUTES);
    });
    $('#timeslice_1hour').click(function() {
      return rManager.changeTimeSlice(TimeSlice.ONE_HOUR);
    });
    $('#timeslice_1day').click(function() {
      return rManager.changeTimeSlice(TimeSlice.ONE_DAY);
    });
    return $('#navigate_back').click(function() {
      return rManager.goBack();
    });
  });
}).call(this);
