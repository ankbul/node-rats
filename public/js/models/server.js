(function() {
  var RServer;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  RServer = (function() {
    RServer.COMMANDS = {
      CHANGE_VIEW: 'change_view',
      EVENTS: 'events'
    };
    RServer.EVENT_TYPE_LIVE = 'live';
    RServer.EVENT_TYPE_HISTORICAL = 'historical';
    RServer.EVENT_TYPE_DISTRIBUTION = 'distribution';
    RServer.TIME_INTERVALS = ['1m', '5m'];
    function RServer(host, port) {
      this.host = host;
      this.port = port;
      this.currentPath = '';
      this.currentType = RServer.EVENT_TYPE_LIVE;
      this.currentInterval = RServer.TIME_INTERVALS[0];
      this.eventData = null;
    }
    RServer.prototype.start = function() {
      this.socket = io.connect(this.host + ":" + this.port);
      this.socket.on(RServer.COMMANDS.EVENTS, __bind(function(data) {
        console.log(data);
        return this.gotEvents(data);
      }, this));
      return this.changeView(this.currentPath, this.currentType, this.currentInterval);
    };
    RServer.prototype.changeView = function(path, type, interval) {
      var view;
      this.currentPath = path;
      this.currentType = type;
      this.currentInterval = interval;
      view = {
        path: this.currentPath,
        type: this.currentType,
        interval: this.currentInterval
      };
      this.eventData = null;
      this.eventView = null;
      return this.socket.emit(RServer.COMMANDS.CHANGE_VIEW, view);
    };
    RServer.prototype.gotEvents = function(data) {
      if (this.currentPath !== data.view.path || this.currentType !== data.view.type || this.currentInterval !== data.view.interval) {
        console.log('View Information Does not match');
        return;
      }
      if (data.type = RServer.EVENT_TYPE_LIVE) {
        if (this.eventData) {
          this.eventData.update(data);
          return this.eventView.updateGraph(this.eventData.toJson());
        } else {
          this.eventData = new REvent(data);
          this.eventView = new RLive(this.currentPath, this.currentInterval);
          $(this.eventView).bind(RLive.EVENT_NAVIGATE, __bind(function(e, data) {
            return this.changeView(data.path, data.type, data.interval);
          }, this));
          return this.eventView.drawGraph(this.eventData.toJson());
        }
      }
    };
    return RServer;
  })();
  window.RServer = RServer;
}).call(this);
