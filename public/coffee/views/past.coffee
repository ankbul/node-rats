class RPast

  constructor : () ->
    @data = []
    for i in [1..10]
      @data.push(null);

  drawGraph : (graphData) ->

    data      = graphData.data
    tooltips  = graphData.tooltips
    keys      = graphData.legend
    colors    = graphData.colors


#    @data = data


    RGraph.Clear(document.getElementById("cvs"))
    graph = @getGraph('cvs', data, tooltips, keys, colors);
    graph.Draw();

#    for d in data
#      @data.push d[1]
#
#    if @data.length > 100
#        @data.splice(0,100);

  getGraph : (id, d, tooltips, keys, colors) ->




    graph = new RGraph.Line(id, d)
    graph.Set('chart.background.barcolor1', 'white')
    graph.Set('chart.background.barcolor2', 'white')
    graph.Set('chart.background.barcolor3', 'white')
    graph.Set('chart.title.xaxis', 'Time')
#    graph.Set('chart.filled', true)
#    graph.Set('chart.fillstyle', ['#3B5998', '#3B5998','#fff','#faa','#faa','#faa','#3B5998','#faa','#faa','#faa'])
    graph.Set('chart.colors', colors)
    graph.Set('chart.linewidth', 3)
    graph.Set('chart.ymax', 100)
    graph.Set('chart.xticks', 25)
    graph.Set('chart.linewidth', 5)
    graph.Set('chart.tickmarks', 'dot')
    graph.Set('chart.tooltips', tooltips)
    graph.Set('chart.tooltips.effect', 'contract')
#    graph.Set('chart.labels.ingraph', d1)
#    graph.Set('chart.labels', tooltips)


    graph.Set('chart.key', keys)
    graph.Set('chart.key.shadow', true)
    graph.Set('chart.key.shadow.offsetx', 0)
    graph.Set('chart.key.shadow.offsety', 0)
    graph.Set('chart.key.shadow.blur', 15)
    graph.Set('chart.key.shadow.color', '#ddd')
    graph.Set('chart.key.rounded', true)
    graph.Set('chart.key.position', 'graph')
    graph.Set('chart.key.position.x', graph.Get('chart.gutter.left') + 4);
    graph.Set('chart.key.position.y', 5);


    return graph;


window.RPast = RPast