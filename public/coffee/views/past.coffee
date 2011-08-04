class RPast

  @MAIN_GRAPH_WIDTH   = 800
  @MAIN_GRAPH_HEIGHT  = 450

  draw : (rootEvent) ->

    # Draw the graph
    if $('#pastCanvas' ).length == 0
      canvas = $('<canvas>')
      canvas.attr('id', 'pastCanvas')
      canvas.attr('width', RPast.MAIN_GRAPH_WIDTH)
      canvas.attr('height', RPast.MAIN_GRAPH_HEIGHT)
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
        canvas.attr('width', 900  )
        canvas.attr('height', 1200)
        div.append(canvas)

        $('#data').append(div)
      else
        div     = $('#' + event.name )
        canvas  = $('#canvas' + event.name)


      graphData = event.getGraphData(RView.PAST_DATA)

      console.log(graphData)


      Graph.drawBarGraph graphData, 'canvas' + event.name






window.RPast = RPast