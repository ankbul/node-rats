(function() {
  var RHistorical;
  RHistorical = (function() {
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
        this.events.push(new REvent(ev, RHistorical.getGraphColor()));
      }
    }
    RHistorical.prototype.getGraphData = function() {
      var colors, ev, keys, results, t, tooltip, tooltips, _i, _j, _len, _len2, _ref;
      results = [];
      tooltips = [];
      keys = [];
      colors = [];
      _ref = this.events;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        ev = _ref[_i];
        keys.push(ev.path);
        colors.push(ev.color);
        results.push(ev.measurements.map(function(e) {
          return e[1];
        }).reverse());
        tooltip = ev.measurements.map(function(e) {
          return e[0];
        }).reverse();
        for (_j = 0, _len2 = tooltip.length; _j < _len2; _j++) {
          t = tooltip[_j];
          tooltips.push(t);
        }
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
        _results.push(ev ? ev.update(newEventData) : this.events.push(new REvent(newEventData, RHistorical.getGraphColor())));
      }
      return _results;
    };
    return RHistorical;
  })();
  window.RHistorical = RHistorical;
}).call(this);
