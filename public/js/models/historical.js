(function() {
  var RHistorical;
  RHistorical = (function() {
    RHistorical.ALL_DATA = 'all';
    RHistorical.NOW_DATA = 'now';
    RHistorical.PAST_DATA = 'past';
    RHistorical.getGraphDataForEvent = function(event) {
      var colors, keys, results, t, tooltip, tooltips, _i, _len;
      results = [];
      tooltips = [];
      keys = [];
      colors = [];
      keys.push(event.path);
      colors.push(event.color);
      results.push(event.measurements.map(function(e) {
        return e[1];
      }).reverse());
      tooltip = event.measurements.map(function(e) {
        return e[0];
      }).reverse();
      for (_i = 0, _len = tooltip.length; _i < _len; _i++) {
        t = tooltip[_i];
        tooltips.push(t);
      }
      return {
        data: results,
        tooltips: tooltips,
        legend: keys,
        colors: colors
      };
    };
    RHistorical.getGraphColor = function() {
      var colors, index;
      colors = ['rgb(169, 222, 244)', '#3B5998', 'red'];
      index = Math.floor(Math.random() * colors.length);
      return colors[index];
    };
    function RHistorical(data) {
      var ev, _i, _len;
      this.events = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        ev = data[_i];
        this.events.push(new Event(ev, RHistorical.getGraphColor()));
      }
    }
    RHistorical.prototype.getGraphData = function(type) {
      var colors, ev, keys, measurements, results, t, tooltip, tooltips, _i, _j, _len, _len2, _ref, _ref2;
      if (type == null) {
        type = RHistorical.ALL_DATA;
      }
      results = [];
      tooltips = [];
      keys = [];
      colors = [];
      _ref = this.events;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        ev = _ref[_i];
        measurements = ev.measurements.map(function(e) {
          return e[1];
        });
        tooltip = ev.measurements.map(function(e) {
          return e[0];
        });
        switch (type) {
          case RHistorical.NOW_DATA:
            measurements = measurements.slice(0, measurements.length / 2);
            tooltip = tooltip.slice(0, tooltip.length / 2);
            break;
          case RHistorical.PAST_DATA:
            measurements = measurements.slice(measurements.length / 2);
            tooltip = tooltip.slice(tooltip.length / 2);
        }
        results.push(measurements.reverse());
        _ref2 = tooltip.reverse();
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          t = _ref2[_j];
          tooltips.push(t);
        }
        keys.push(ev.path);
        colors.push(ev.color);
      }
      return {
        data: results,
        tooltips: tooltips,
        legend: keys,
        colors: colors
      };
    };
    RHistorical.prototype.getByPath = function(path) {
      var ev, _i, _len, _ref;
      _ref = this.events;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        ev = _ref[_i];
        if (ev.path === path) {
          return ev;
        }
      }
      return null;
    };
    RHistorical.prototype.update = function(data) {
      var ev, newEventData, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        newEventData = data[_i];
        ev = this.getByPath(newEventData.path);
        _results.push(ev ? ev.update(newEventData) : this.events.push(new Event(newEventData, RHistorical.getGraphColor())));
      }
      return _results;
    };
    return RHistorical;
  })();
  window.RHistorical = RHistorical;
}).call(this);
