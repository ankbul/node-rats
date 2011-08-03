(function() {
  var RView;
  RView = (function() {
    function RView() {}
    RView.VIEW_LIVE = 'live';
    RView.VIEW_HISTORICAL = 'historical';
    RView.ALL_DATA = 'all';
    RView.NOW_DATA = 'now';
    RView.PAST_DATA = 'past';
    return RView;
  })();
  window.RView = RView;
}).call(this);
