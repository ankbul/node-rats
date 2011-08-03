class RPast

  constructor : () ->


  @drawExpandedData : (graphData) ->
    data      = graphData.data
    tooltips  = graphData.tooltips
    keys      = graphData.legend
    colors    = graphData.colors


    topLeftCornerX = 188;
    topLeftCornerY = 50;
    width = 200;
    height = 100;

    $('#data').empty()



#      context = canvas.getContext('2d')
#      context.beginPath()
#      context.rect(topLeftCornerX, topLeftCornerY, width, height)
#
#      context.fillStyle = "#8ED6FF"
#      context.fill()
#      context.lineWidth = 5
#      context.strokeStyle = "black"
#      context.stroke()




    keys.forEach( (key, index) ->
      div = $('<div>')
      div.html(key)
      $('#data').append(div)

      graphValues = data[index]

      graphValues.forEach ( (value, indexData) ->
        div = $('<div>')
        div.html(tooltips[indexData] + ' ' + value)

        canvas = $('<canvas>')
        canvas.drawRect({
          fillStyle: "#8ED6FF",
          x: 0, y: 0,
          width: 200,
          height: 10,
          fromCenter: false
        })
        div.append(canvas)

        div.hide()



        $('#data').append(div)
      )
    )


  @drawGraph : (graphData, canvasId = 'cvs') ->

    data      = graphData.data
    tooltips  = graphData.tooltips
    keys      = graphData.legend
    colors    = graphData.colors

    RGraph.Clear(document.getElementById(canvasId))
    graph = @getGraph(canvasId, data, tooltips, keys, colors)
    graph.Draw()



#    if $('#' + event.name ).length == 0
#      div = $('#template_live').clone()
#      div.attr('id', event.name)
#      div.find('#live_cvs').attr('id', 'canvas' + event.name)
#      div.show()
#      @addNextClick div, event
#      $('#data').append(div)
#    else
#      div = $('#' + event.name )



  @getGraph : (id, d, tooltips, keys, colors) ->
    graph = new RGraph.Line(id, d)

    ymax = -1
    for data in d
      for data2 in data
        if parseInt(data2) > parseInt(ymax)
          ymax = parseInt(data2)
    ymax = parseInt(ymax * 1.10)

    graph.Set('chart.background.barcolor1', 'white')
    graph.Set('chart.title.xaxis', 'Time ' + tooltips[0]  + ' ' + tooltips[tooltips.length - 1] )
    graph.Set('chart.colors', colors)
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