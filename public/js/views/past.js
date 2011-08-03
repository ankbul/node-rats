(function() {
  var RPast;
  RPast = (function() {
    function RPast() {}
    RPast.prototype.draw = function(rootEvent) {
      var canvas, div, event, graphData, _i, _len, _ref, _results;
      if ($('#pastCanvas').length === 0) {
        canvas = $('<canvas>');
        canvas.attr('id', 'pastCanvas');
        $('#data').append(canvas);
      }
      graphData = rootEvent.getSubEventsGraphData(RView.NOW_DATA);
      Graph.drawLineGraph(graphData, 'pastCanvas');
      _ref = rootEvent.events;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        event = _ref[_i];
        if ($('#' + event.name).length === 0) {
          div = $('<div>');
          div.attr('id', event.name);
          div.show();
          div.html(event.name);
          canvas = $('<canvas>');
          canvas.attr('id', 'canvas' + event.name);
          canvas.attr('width', 800);
          canvas.attr('height', 1000);
          div.append(canvas);
          $('#data').append(div);
        } else {
          div = $('#' + event.name);
          canvas = $('#canvas' + event.name);
        }
        graphData = event.getGraphData();
        _results.push(Graph.drawBarGraph(graphData, 'canvas' + event.name));
      }
      return _results;
    };
    return RPast;
  })();
  window.RPast = RPast;
}).call(this);
