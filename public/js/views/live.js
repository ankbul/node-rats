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
    RLive.prototype.drawGraph = function(data) {
      var title;
      $("#chart").empty();
      this.vis = d3.select("#chart").selectAll("svg").data(data).enter().append("svg:svg").attr("class", "bullet").attr("width", this.w).attr("height", this.h).attr("id", function(d) {
        return d.title;
      }).on('click', __bind(function(d) {
        console.log('Trying to trigger an event');
        console.log("path " + d.obj.path);
        return $(this).trigger(RLive.EVENT_NAVIGATE, {
          path: d.obj.path,
          type: RServer.EVENT_TYPE_LIVE,
          interval: this.timeSlice
        });
      }, this)).append("svg:g").attr("transform", "translate(" + this.m[3] + "," + this.m[0] + ")").call(this.chart);
      title = this.vis.append("svg:g").attr("text-anchor", "end").attr("transform", "translate(-6," + (this.h - this.m[0] - this.m[2]) / 2 + ")");
      title.append("svg:text").attr("class", "title").text(function(d) {
        return d.title;
      });
      title.append("svg:text").attr("class", "subtitle").attr("dy", "1em").text(function(d) {
        return d.subtitle;
      });
      return this.chart.duration(500);
    };
    RLive.prototype.updateGraph = function(data) {
      var title;
      this.vis.data(data);
      this.vis.call(this.chart);
      d3.select("#chart").selectAll("svg").selectAll("text.title").remove();
      d3.select("#chart").selectAll("svg").selectAll("text.subtitle").remove();
      title = this.vis.append("svg:g").attr("text-anchor", "end").attr("transform", "translate(-6," + (this.h - this.m[0] - this.m[2]) / 2 + ")");
      title.append("svg:text").attr("class", "title").text(function(d) {
        return d.title;
      });
      return title.append("svg:text").attr("class", "subtitle").attr("dy", "1em").text(function(d) {
        return d.subtitle;
      });
    };
    return RLive;
  })();
  window.RLive = RLive;
}).call(this);
