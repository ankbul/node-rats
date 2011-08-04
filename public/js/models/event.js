(function() {
  var Event;
  Event = (function() {
    Event.getGraphColor = function() {
      var colors, index;
      colors = ['#00c176', '#ff0096', '#d1d400'];
      index = Math.floor(Math.random() * colors.length);
      return colors[index];
    };
    function Event(data, color) {
      var ev, _i, _len, _ref, _ref2, _ref3, _ref4, _ref5, _ref6;
      this.events = [];
      this.count = (_ref = data.count) != null ? _ref : 0;
      this.name = (_ref2 = data.name) != null ? _ref2 : '';
      this.path = (_ref3 = data.path) != null ? _ref3 : '';
      this.color = color != null ? color : Event.getGraphColor();
      this.measurements = (_ref4 = data.measurements) != null ? _ref4 : [];
      this.previousCount = (_ref5 = data.previousCount) != null ? _ref5 : 0;
      if (data.events) {
        _ref6 = data.events;
        for (_i = 0, _len = _ref6.length; _i < _len; _i++) {
          ev = _ref6[_i];
          this.events.push(new Event(ev));
        }
      }
    }
    Event.prototype.update = function(data) {
      var ev, evData, _i, _len, _ref, _ref2, _ref3, _results;
      this.count = data.count || 0;
      this.name = data.name || '';
      this.path = data.path || '';
      this.measurements = (_ref = data.measurements) != null ? _ref : [];
      this.previousCount = (_ref2 = data.previousCount) != null ? _ref2 : 0;
      if (!data.events) {
        this.events = [];
        return;
      }
      _ref3 = data.events;
      _results = [];
      for (_i = 0, _len = _ref3.length; _i < _len; _i++) {
        evData = _ref3[_i];
        ev = this.getByPath(evData.path);
        _results.push(ev === null ? this.events.push(new Event(evData)) : ev.update(evData));
      }
      return _results;
    };
    Event.prototype.getByPath = function(path) {
      var event, _i, _len, _ref;
      _ref = this.events;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        event = _ref[_i];
        if (event.path === path) {
          return event;
        }
      }
      return null;
    };
    Event.prototype.getGraphData = function(showPrevious) {
      var graphData;
      if (showPrevious == null) {
        showPrevious = false;
      }
      this.nowData = this.measurements.slice(0, this.measurements.length / 2);
      this.previousData = this.measurements.slice(this.measurements.length / 2);
      graphData = {
        data: [
          this.nowData.map(function(e) {
            return e[1];
          }).reverse()
        ],
        tooltips: this.nowData.map(function(e) {
          return e[0];
        }).reverse(),
        legend: [this.path],
        colors: [this.color]
      };
      if (showPrevious) {
        graphData.data = [
          this.previousData.map(function(e) {
            return e[1];
          }).reverse()
        ].concat(graphData.data);
        graphData.tooltips = this.previousData.map(function(e) {
          return e[0];
        }).reverse().concat(graphData.tooltips);
        graphData.colors = ['#CCC'].concat(graphData.colors);
        graphData.legend = ['past'].concat(graphData.legend);
      }
      return graphData;
    };
    return Event;
  })();
  window.Event = Event;
}).call(this);
