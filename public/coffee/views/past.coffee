class RPast

  draw : (rootEvent) ->

#    data      = graphData.data
#    tooltips  = graphData.tooltips
#    keys      = graphData.legend
#    colors    = graphData.colors
#
#    if $('#' +canvasId).length == 0
#      canvas = $('<canvas>')
#      canvas.attr('id', canvasId)
#      canvas.attr('width','800')
#      canvas.attr('height','450')
#      $('#data').append(canvas)
#
#    RGraph.Clear(document.getElementById(canvasId))
#    graph = @getLineGraph(canvasId, data, tooltips, keys, colors)
#    graph.Draw()

    # Draw the graph
    if $('#pastCanvas' ).length == 0
      canvas = $('<canvas>')
      canvas.attr('id', 'pastCanvas')
      $('#data').append(canvas)


    graphData = rootEvent.getSubEventsGraphData(RView.NOW_DATA)
    Graph.drawLineGraph graphData, 'pastCanvas'



    # Draw the expanded
    for event in rootEvent.events
      if $('#' + event.name ).length == 0
        div = $('<div>')
        div.attr('id', event.name)
        div.show()
        div.html(event.name)

        canvas = $('<canvas>')
        canvas.attr('id', 'canvas' + event.name)
        canvas.attr('width', 800)
        canvas.attr('height', 1000)
        div.append(canvas)

        $('#data').append(div)
      else
        div     = $('#' + event.name )
        canvas  = $('#canvas' + event.name)

      graphData = event.getGraphData()
      Graph.drawBarGraph graphData, 'canvas' + event.name






window.RPast = RPast