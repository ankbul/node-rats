class RLive

  @EVENT_NAVIGATE : "rlive-navigate"

  constructor: (path, timeSlice) ->
    @path = path
    @timeSlice = timeSlice

    @w = 960
    @h = 50
    @m = [5, 40, 20, 120]
    @chart = d3.chart.bullet().width(@w - @m[1] - @m[3]).height(@h - @m[0] - @m[2])

  addNextClick : (element, event) ->
    element.click(() =>
      if event.events.length > 0
        $(@).trigger(RLive.EVENT_NAVIGATE, {path: event.path, type: RManager.EVENT_TYPE_LIVE, timeSlice: @timeSlice})
    )

  drawGraph: (data) ->
    console.log(data)
    topCount = data.count

    for event in data.events
      if $('#' + event.name ).length == 0
        div = $('#template_live').clone()
        div.attr('id', event.name)
        div.show()
        @addNextClick div, event
        div.find('.live_count').html(event.count)
        div.find('.live_title').html(event.name)
        div.find('.live_ratio').html( parseInt(event.count * 100 / topCount) + '%')
        $('#data').append(div)
      else
        div = $('#' + event.name )
        div.find('.live_count').html(event.count)
        div.find('.live_title').html(event.name)
        div.find('.live_ratio').html( parseInt(event.count * 100 / topCount) + '%')


#    $("#chart").empty()
#    @vis = d3.select("#chart").selectAll("svg")
#      .data(data)
#      .enter().append("svg:svg")
#      .attr("class", "bullet")
#      .attr("width", @w)
#      .attr("height", @h)
#      .attr("id", (d) -> return d.title)
#      .on('click', (d) =>
#        console.log 'Trying to trigger an event'
#        console.log "path " + d.obj.path
#        $(@).trigger(RLive.EVENT_NAVIGATE, {path: d.obj.path, type: RServer.EVENT_TYPE_LIVE, timeSlice: @timeSlice})
##        drawGraph(d.obj.toJson())
#      )
#      .append("svg:g")
#      .attr("transform", "translate(" + @m[3] + "," + @m[0] + ")")
#      .call(@chart)
#
#    title = @vis.append("svg:g")
#      .attr("text-anchor", "end")
#      .attr("transform", "translate(-6," + (@h - @m[0] - @m[2]) / 2 + ")")
#
#    title.append("svg:text")
#      .attr("class", "title")
#      .text( (d) -> return d.title)
#
#    title.append("svg:text")
#      .attr("class", "subtitle")
#      .attr("dy", "1em")
#      .text((d) -> return d.subtitle)
#
#    @chart.duration(500)

  updateGraph: (data) ->
    @drawGraph(data)
#    @vis.data(data)
#    @vis.call(@chart)
#
#    d3.select("#chart").selectAll("svg").selectAll("text.title").remove()
#    d3.select("#chart").selectAll("svg").selectAll("text.subtitle").remove()
#
#    title = @vis.append("svg:g")
#      .attr("text-anchor", "end")
#      .attr("transform", "translate(-6," + (@h - @m[0] - @m[2]) / 2 + ")")
#
#    title.append("svg:text")
#      .attr("class", "title")
#      .text((d) -> return d.title )
#
#    title.append("svg:text")
#      .attr("class", "subtitle")
#      .attr("dy", "1em")
#      .text((d) -> return d.subtitle )

window.RLive = RLive




