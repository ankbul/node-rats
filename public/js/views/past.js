(function() {
  var RPast;
  RPast = (function() {
    function RPast() {
      var i;
      this.data = [];
      for (i = 1; i <= 10; i++) {
        this.data.push(null);
      }
    }
    RPast.prototype.drawGraph = function(graphData) {
      var colors, data, graph, keys, tooltips;
      data = graphData.data;
      tooltips = graphData.tooltips;
      keys = graphData.legend;
      colors = graphData.colors;
      RGraph.Clear(document.getElementById("cvs"));
      graph = this.getGraph('cvs', data, tooltips, keys, colors);
      return graph.Draw();
    };
    RPast.prototype.getGraph = function(id, d, tooltips, keys, colors) {
      var graph;
      graph = new RGraph.Line(id, d);
      graph.Set('chart.background.barcolor1', 'white');
      graph.Set('chart.background.barcolor2', 'white');
      graph.Set('chart.background.barcolor3', 'white');
      graph.Set('chart.title.xaxis', 'Time');
      graph.Set('chart.colors', colors);
      graph.Set('chart.linewidth', 3);
      graph.Set('chart.ymax', 100);
      graph.Set('chart.xticks', 25);
      graph.Set('chart.linewidth', 5);
      graph.Set('chart.tickmarks', 'dot');
      graph.Set('chart.tooltips', tooltips);
      graph.Set('chart.tooltips.effect', 'contract');
      graph.Set('chart.key', keys);
      graph.Set('chart.key.shadow', true);
      graph.Set('chart.key.shadow.offsetx', 0);
      graph.Set('chart.key.shadow.offsety', 0);
      graph.Set('chart.key.shadow.blur', 15);
      graph.Set('chart.key.shadow.color', '#ddd');
      graph.Set('chart.key.rounded', true);
      graph.Set('chart.key.position', 'graph');
      graph.Set('chart.key.position.x', graph.Get('chart.gutter.left') + 4);
      graph.Set('chart.key.position.y', 5);
      return graph;
    };
    return RPast;
  })();
  window.RPast = RPast;
}).call(this);
