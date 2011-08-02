(function() {
  var RLive;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  RLive = (function() {
    RLive.EVENT_NAVIGATE = "rlive-navigate";
    function RLive(path, timeSlice) {
      this.path = path;
      this.timeSlice = timeSlice;
      this.w = 960;
      this.h = 50;
      this.m = [5, 40, 20, 120];
      this.chart = d3.chart.bullet().width(this.w - this.m[1] - this.m[3]).height(this.h - this.m[0] - this.m[2]);
    }
    RLive.prototype.addNextClick = function(element, event) {
      return element.click(__bind(function() {
        if (event.events.length > 0) {
          return $(this).trigger(RLive.EVENT_NAVIGATE, {
            path: event.path,
            type: RManager.EVENT_TYPE_LIVE,
            timeSlice: this.timeSlice
          });
        }
      }, this));
    };
    RLive.prototype.drawGraph = function(data) {
      var div, event, graphData, topCount, _i, _len, _ref, _results;
      console.log(data);
      topCount = data.count;
      _ref = data.events;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        event = _ref[_i];
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
        div.find('.live_ratio').html(parseInt(event.count * 100 / topCount) + '%');
        div.find('.live_change_rate').html(parseInt(event.count * 100 / event.previousCount) + '%');
        graphData = RHistorical.getGraphDataForEvent(event);
        _results.push(RPast.drawGraph(graphData, 'canvas' + event.name));
      }
      return _results;
    };
    RLive.prototype.updateGraph = function(data) {
      return this.drawGraph(data);
    };
    return RLive;
  })();
  window.RLive = RLive;
}).call(this);
