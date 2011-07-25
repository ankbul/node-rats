(function() {
  var REvent;
  REvent = (function() {
    function REvent(data) {
      var ev, _i, _len, _ref;
      this.count = data.count || 0;
      this.name = data.name || '';
      this.path = data.path || '';
      this.events = [];
      if (data.events) {
        _ref = data.events;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          ev = _ref[_i];
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
    return REvent;
  })();
  window.REvent = REvent;
}).call(this);
