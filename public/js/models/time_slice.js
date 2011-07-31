(function() {
  var TimeSlice;
  TimeSlice = (function() {
    function TimeSlice() {}
    TimeSlice.ALL = 'all';
    TimeSlice.ONE_MINUTE = '1m';
    TimeSlice.FIVE_MINUTES = '5m';
    TimeSlice.TEN_MINUTES = '10m';
    TimeSlice.ONE_HOUR = '1h';
    TimeSlice.ONE_DAY = '1d';
    return TimeSlice;
  })();
  window.TimeSlice = TimeSlice;
}).call(this);
