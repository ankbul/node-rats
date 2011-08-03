(function() {
  var RManager;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  RManager = (function() {
    function RManager(host, port, container) {
      this.host = host;
      this.port = port != null ? port : 3030;
      this.container = container;
      this.currentPath = '/';
      this.currentType = RView.VIEW_LIVE;
      this.currentTimeSlice = TimeSlice.ONE_MINUTE;
      this.eventData = null;
      this.historyStack = [];
    }
    RManager.prototype.start = function() {
      this.socket = io.connect(this.host + ":" + this.port);
      this.socket.on(Commands.CONNECTED, __bind(function(data) {
        return this.changeView();
      }, this));
      return this.socket.on(Commands.EVENTS, __bind(function(data) {
        return this.gotEvents(data);
      }, this));
    };
    RManager.prototype.goBack = function() {
      var path;
      path = this.historyStack.pop();
      if ((path === '') || (path !== void 0)) {
        return this.changeView(path);
      }
    };
    RManager.prototype.changeTimeSlice = function(timeSlice) {
      return this.changeView(null, null, timeSlice);
    };
    RManager.prototype.changePath = function(path) {
      this.historyStack.push(this.currentPath);
      return this.changeView(path);
    };
    RManager.prototype.changeType = function(type) {
      return this.changeView(null, type, null);
    };
    RManager.prototype.changeView = function(path, type, timeSlice) {
      var view;
      this.container.empty();
      this.eventData = null;
      this.eventView = null;
      if (path !== void 0 && path !== null) {
        this.currentPath = path;
      }
      this.currentType = type || this.currentType;
      this.currentTimeSlice = timeSlice || this.currentTimeSlice;
      view = {
        path: this.currentPath,
        type: this.currentType,
        timeSlice: this.currentTimeSlice
      };
      return this.socket.emit(Commands.CHANGE_VIEW, view);
    };
    RManager.prototype.gotEvents = function(data) {
      var graphData;
      console.log(data);
      if (this.currentPath !== data.view.path || this.currentType !== data.view.type || this.currentTimeSlice !== data.view.timeSlice) {
        console.log('View Information Does not match');
        return;
      }
      if (data.view.type === RView.VIEW_LIVE) {
        if (this.eventData) {
          this.eventData.update(data.eventTree);
          return this.eventView.updateGraph(this.eventData);
        } else {
          this.eventData = new Event(data.eventTree);
          this.eventView = new RLive(this.currentPath, this.currentTimeSlice);
          $(this.eventView).bind(RLive.EVENT_NAVIGATE, __bind(function(e, data) {
            return this.changePath(data.path);
          }, this));
          return this.eventView.drawGraph(this.eventData);
        }
      } else if (data.view.type = RView.VIEW_HISTORICAL) {
        if (this.eventData) {
          this.eventData.update(data.eventList);
        } else {
          this.eventData = new RHistorical(data.eventList);
        }
        graphData = this.eventData.getGraphData();
        RPast.drawGraph(graphData);
        return RPast.drawExpandedData(graphData);
      }
    };
    return RManager;
  })();
  window.RManager = RManager;
}).call(this);
