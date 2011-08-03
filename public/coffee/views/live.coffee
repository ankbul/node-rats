class RLive

  @EVENT_NAVIGATE : "rlive-navigate"

  constructor: (path, timeSlice) ->
    @path = path
    @timeSlice = timeSlice

  addNextClick : (element, event) ->
    element.click () =>
      if event.events.length > 0
        data = {
          path: event.path,
          type: RManager.EVENT_TYPE_LIVE,
          timeSlice: @timeSlice
        }
        $(@).trigger(RLive.EVENT_NAVIGATE, data)

  drawGraph: (data) ->
    console.log(data)
    topCount = data.count

    for event in data.events
      if $('#' + event.name ).length == 0
        div = $('#template_live').clone()
        div.attr('id', event.name)
        div.find('#live_cvs').attr('id', 'canvas' + event.name)
        div.show()
        @addNextClick div, event
        $('#data').append(div)
      else
        div = $('#' + event.name )

      div.find('.live_count').html(event.count)
      div.find('.live_title').html(event.name)
      div.find('.live_ratio').html( parseInt(event.count * 100 / topCount) + '%')
      div.find('.live_change_rate').html( parseInt(event.count * 100 / event.previousCount) + '%')

      graphData = event.getGraphData(true)
      RPast.drawGraph graphData, 'canvas' + event.name


  updateGraph: (data) ->
    @drawGraph(data)

window.RLive = RLive




