(function() {
  var Commands;
  Commands = (function() {
    function Commands() {}
    Commands.CONNECTED = 'connection';
    Commands.CHANGE_VIEW = 'change_view';
    Commands.EVENTS = 'events';
    return Commands;
  })();
  window.Commands = Commands;
}).call(this);
