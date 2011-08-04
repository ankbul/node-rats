(function() {
  var RLive;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  RLive = (function() {
    RLive.EVENT_NAVIGATE = "rlive-navigate";
    function RLive(path, timeSlice) {
      this.path = path;
      this.timeSlice = timeSlice;
    }
    RLive.prototype.draw = function(data) {
      var div, event, graphData, topCount, _i, _j, _len, _len2, _ref, _ref2, _results;
      topCount = -1;
      _ref = data.events;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        event = _ref[_i];
        topCount = Math.max(event.count, topCount);
      }
      _ref2 = data.events;
      _results = [];
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        event = _ref2[_j];
        if ($('#' + event.name).length === 0) {
          div = $('#template_live').clone();
          div.attr('id', event.name);
          div.find('#live_cvs').attr('id', 'canvas' + event.name);
          div.show();
          this.addNextClick(div, event);
          $('#data').append(div);
        } else {
          div = $('#' + event.name);
        }
        div.find('.live_count').html(event.count);
        div.find('.live_title').html(event.name);
        if (topCount > 0) {
          div.find('.live_ratio').html(parseInt(event.count * 100 / topCount) + '%');
        } else {
          div.find('.live_ratio').html('');
        }
        if (event.previousCount > 0) {
          div.find('.live_change_rate').html(parseInt(event.count * 100 / event.previousCount) + '%');
        } else {
          div.find('.live_change_rate').html('');
        }
        graphData = event.getGraphLiveData(true);
        _results.push(Graph.drawLineGraph(graphData, 'canvas' + event.name));
      }
      return _results;
    };
    RLive.prototype.addNextClick = function(element, event) {
      return element.click(__bind(function() {
        var data;
        if (event.events.length > 0) {
          data = {
            path: event.path,
            type: RManager.EVENT_TYPE_LIVE,
            timeSlice: this.timeSlice
          };
          return $(this).trigger(RLive.EVENT_NAVIGATE, data);
        }
      }, this));
    };
    return RLive;
  })();
  window.RLive = RLive;
}).call(this);
