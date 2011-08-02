class RPast

  constructor : () ->


  @drawGraph : (graphData, canvasId = 'cvs') ->

    data      = graphData.data
    tooltips  = graphData.tooltips
    keys      = graphData.legend
    colors    = graphData.colors

    RGraph.Clear(document.getElementById(canvasId))
    graph = @getGraph(canvasId, data, tooltips, keys, colors);
    graph.Draw();


  @getGraph : (id, d, tooltips, keys, colors) ->
    graph = new RGraph.Line(id, d)

    ymax = -1
    for data in d
      for data2 in data
        if parseInt(data2) > parseInt(ymax)
          ymax = parseInt(data2)
    ymax = parseInt(ymax * 1.10)

    console.log(tooltips)

    graph.Set('chart.background.barcolor1', 'white')
    graph.Set('chart.background.barcolor2', 'white')
    graph.Set('chart.background.barcolor3', 'white')
    graph.Set('chart.title.xaxis', 'Time ' + tooltips[0]  + ' ' + tooltips[tooltips.length - 1] )
    graph.Set('chart.colors', colors)
    graph.Set('chart.linewidth', 3)
    graph.Set('chart.ymax', ymax)
    graph.Set('chart.linewidth', 5)
    graph.Set('chart.tickmarks', 'dot')
    graph.Set('chart.tooltips', tooltips)
    graph.Set('chart.tooltips.effect', 'contract')


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