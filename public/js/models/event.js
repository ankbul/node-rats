(function() {
  var REvent;
  REvent = (function() {
    function REvent(data, color) {
      var ev, _i, _len, _ref, _ref2, _ref3, _ref4, _ref5, _ref6;
      this.count = (_ref = data.count) != null ? _ref : 0;
      this.name = (_ref2 = data.name) != null ? _ref2 : '';
      this.path = (_ref3 = data.path) != null ? _ref3 : '';
      this.color = color != null ? color : RHistorical.getGraphColor();
      this.measurements = (_ref4 = data.measurements.slice(0, data.measurements.length / 2)) != null ? _ref4 : [];
      this.events = [];
      this.previousCount = (_ref5 = data.previousCount) != null ? _ref5 : 0;
      if (data.events) {
        _ref6 = data.events;
        for (_i = 0, _len = _ref6.length; _i < _len; _i++) {
          ev = _ref6[_i];
          this.events.push(new REvent(ev));
        }
      }
    }
    REvent.prototype.toJson = function() {
      var data, event, maxRange, _i, _j, _len, _len2, _ref, _ref2;
      data = [];
      maxRange = -1;
      _ref = this.events;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        event = _ref[_i];
        if (event.count > maxRange) {
          maxRange = event.count;
        }
      }
      data = [];
      _ref2 = this.events;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        event = _ref2[_j];
        data.push({
          title: event.name,
          subtitle: "Count " + event.count,
          ranges: [maxRange],
          measures: [event.count],
          markers: [maxRange],
          obj: event
        });
      }
      return data;
    };
    REvent.prototype.getEvent = function(path) {
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
    REvent.prototype.update = function(data) {
      var ev, newEventData, _i, _len, _ref, _ref2, _ref3, _results;
      this.count = data.count || 0;
      this.name = data.name || '';
      this.path = data.path || '';
      this.measurements = (_ref = data.measurements.slice(0, data.measurements.length / 2)) != null ? _ref : [];
      this.previousCount = (_ref2 = data.previousCount) != null ? _ref2 : 0;
      if (!data.events) {
        this.events = [];
        return;
      }
      _ref3 = data.events;
      _results = [];
      for (_i = 0, _len = _ref3.length; _i < _len; _i++) {
        newEventData = _ref3[_i];
        ev = this.getEvent(newEventData.path);
        _results.push(ev === null ? this.events.push(new REvent(newEventData)) : ev.update(newEventData));
      }
      return _results;
    };
    return REvent;
  })();
  window.REvent = REvent;
}).call(this);
